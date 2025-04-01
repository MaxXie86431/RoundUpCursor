# RoundUp Backend

This is the backend service for the RoundUp social media app, providing APIs for friend recommendations, group management, and user interactions.

## Features

- Friend recommendation system using NLP and interest matching
- Group recommendations based on member interests
- Integration with Supabase for data storage
- FastAPI-based REST API
- Authentication and authorization

## Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Create a `.env` file with the following variables:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SECRET_KEY=your_secret_key
```

4. Run the development server:
```bash
uvicorn app.main:app --reload
```

## API Documentation

Once the server is running, you can access:
- Interactive API docs: http://localhost:8000/docs
- Alternative API docs: http://localhost:8000/redoc

## Project Structure

```
backend/
├── app/
│   ├── api/              # API endpoints
│   ├── core/             # Core functionality
│   ├── models/           # Data models
│   ├── services/         # Business logic
│   └── ml/              # Machine learning models
├── requirements.txt      # Project dependencies
└── README.md            # This file
```

## API Endpoints

### Recommendations
- GET `/api/recommendations/friends/{user_id}` - Get friend recommendations
- GET `/api/recommendations/groups/{user_id}` - Get group recommendations

### Users
- GET `/api/users/{user_id}` - Get user profile
- PUT `/api/users/{user_id}` - Update user profile

### Groups
- POST `/api/groups/` - Create a new group
- GET `/api/groups/{group_id}` - Get group details
- PUT `/api/groups/{group_id}` - Update group
- DELETE `/api/groups/{group_id}` - Delete group

## Development

1. Install development dependencies:
```bash
pip install -r requirements-dev.txt
```

2. Run tests:
```bash
pytest
```

3. Format code:
```bash
black .
```

4. Check types:
```bash
mypy .
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request 