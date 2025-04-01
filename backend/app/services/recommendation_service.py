from typing import List, Dict
import nltk
from nltk.corpus import wordnet
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

class RecommendationService:
    def __init__(self):
        # Download required NLTK data
        try:
            nltk.data.find('tokenizers/punkt')
            nltk.data.find('corpora/wordnet')
        except LookupError:
            nltk.download('punkt')
            nltk.download('wordnet')
            nltk.download('averaged_perceptron_tagger')
        
        self.lemmatizer = WordNetLemmatizer()
        self.vectorizer = TfidfVectorizer()
    
    def preprocess_text(self, text: str) -> str:
        """Preprocess text by tokenizing, lemmatizing, and normalizing"""
        tokens = word_tokenize(text.lower())
        lemmatized = [self.lemmatizer.lemmatize(token) for token in tokens]
        return " ".join(lemmatized)
    
    def calculate_interest_similarity(self, user1_interests: Dict, user2_interests: Dict) -> float:
        """Calculate similarity score between two users based on their interests"""
        score = 0
        
        # School match (worth 5 points)
        if user1_interests.get("school") == user2_interests.get("school"):
            score += 5
        
        # Compare other interests (1 point each)
        interest_categories = [
            "clubs", "videoGames", "hobbies", "careerAspirations",
            "classes", "pets", "sports"
        ]
        
        for category in interest_categories:
            user1_items = set(user1_interests.get(category, []))
            user2_items = set(user2_interests.get(category, []))
            
            # Preprocess all items
            user1_processed = {self.preprocess_text(item) for item in user1_items}
            user2_processed = {self.preprocess_text(item) for item in user2_items}
            
            # Direct matches
            matches = user1_processed.intersection(user2_processed)
            score += len(matches)
            
            # Find similar but not exact matches using word embeddings
            remaining1 = user1_processed - matches
            remaining2 = user2_processed - matches
            
            if remaining1 and remaining2:
                # Create TF-IDF vectors
                all_interests = list(remaining1) + list(remaining2)
                tfidf_matrix = self.vectorizer.fit_transform(all_interests)
                
                # Calculate similarity between remaining interests
                similarity_matrix = cosine_similarity(
                    tfidf_matrix[:len(remaining1)],
                    tfidf_matrix[len(remaining1):]
                )
                
                # Add score for similar interests (threshold > 0.8)
                similar_matches = np.sum(similarity_matrix > 0.8)
                score += similar_matches
        
        return score
    
    def get_friend_recommendations(self, user_id: str, all_users: List[Dict], max_recommendations: int = 10) -> List[Dict]:
        """Get friend recommendations for a user"""
        user = next((u for u in all_users if u["id"] == user_id), None)
        if not user:
            return []
        
        # Calculate similarity scores with all other users
        scores = []
        for other_user in all_users:
            if other_user["id"] != user_id:
                similarity = self.calculate_interest_similarity(
                    user.get("interests", {}),
                    other_user.get("interests", {})
                )
                scores.append((other_user, similarity))
        
        # Sort by similarity score and return top recommendations
        scores.sort(key=lambda x: x[1], reverse=True)
        recommendations = [
            {
                "user": user,
                "score": score,
                "common_interests": self.get_common_interests(
                    user.get("interests", {}),
                    user.get("interests", {})
                )
            }
            for user, score in scores[:max_recommendations]
        ]
        
        return recommendations
    
    def get_common_interests(self, user1_interests: Dict, user2_interests: Dict) -> Dict[str, List[str]]:
        """Get common interests between two users by category"""
        common = {}
        categories = [
            "clubs", "videoGames", "hobbies", "careerAspirations",
            "classes", "pets", "sports"
        ]
        
        for category in categories:
            user1_items = set(user1_interests.get(category, []))
            user2_items = set(user2_interests.get(category, []))
            common_items = user1_items.intersection(user2_items)
            if common_items:
                common[category] = list(common_items)
        
        if user1_interests.get("school") == user2_interests.get("school"):
            common["school"] = user1_interests["school"]
        
        return common 