from fastapi import APIRouter, Depends, HTTPException
from typing import List
from app.services.recommendation_service import RecommendationService
from app.core.auth import get_current_user
from app.models.user import User
from app.core.supabase import get_supabase_client

router = APIRouter()
recommendation_service = RecommendationService()

@router.get("/friends/{user_id}", response_model=List[dict])
async def get_friend_recommendations(
    user_id: str,
    current_user: User = Depends(get_current_user),
    max_recommendations: int = 10
):
    """Get friend recommendations for a user"""
    # Verify the requesting user is the same as the target user
    if current_user.id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to get recommendations for other users")
    
    try:
        # Get Supabase client
        supabase = get_supabase_client()
        
        # Get all users from Supabase
        response = supabase.table("profiles").select("*").execute()
        all_users = response.data
        
        # Get recommendations
        recommendations = recommendation_service.get_friend_recommendations(
            user_id=user_id,
            all_users=all_users,
            max_recommendations=max_recommendations
        )
        
        return recommendations
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/groups/{user_id}", response_model=List[dict])
async def get_group_recommendations(
    user_id: str,
    current_user: User = Depends(get_current_user),
    max_recommendations: int = 10
):
    """Get group recommendations for a user"""
    if current_user.id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to get recommendations for other users")
    
    try:
        # Get Supabase client
        supabase = get_supabase_client()
        
        # Get user's interests
        user_response = supabase.table("profiles").select("*").eq("id", user_id).single().execute()
        user = user_response.data
        
        # Get all groups
        groups_response = supabase.table("groups").select("*").execute()
        groups = groups_response.data
        
        # Get group members for each group
        for group in groups:
            members_response = supabase.table("group_members").select("user_id").eq("group_id", group["id"]).execute()
            group["members"] = [member["user_id"] for member in members_response.data]
        
        # Filter out groups the user is already in
        available_groups = [group for group in groups if user_id not in group["members"]]
        
        # Calculate group scores based on member interests
        group_scores = []
        for group in available_groups:
            # Get interests of group members
            member_interests = []
            for member_id in group["members"]:
                member_response = supabase.table("profiles").select("*").eq("id", member_id).single().execute()
                if member_response.data:
                    member_interests.append(member_response.data.get("interests", {}))
            
            # Calculate average similarity with group members
            total_score = sum(
                recommendation_service.calculate_interest_similarity(user.get("interests", {}), member_interest)
                for member_interest in member_interests
            )
            avg_score = total_score / len(member_interests) if member_interests else 0
            
            group_scores.append((group, avg_score))
        
        # Sort groups by score and return top recommendations
        group_scores.sort(key=lambda x: x[1], reverse=True)
        recommendations = [
            {
                "group": group,
                "score": score,
                "member_count": len(group["members"])
            }
            for group, score in group_scores[:max_recommendations]
        ]
        
        return recommendations
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 