# RoundUp

A social media app designed to help users find new friends based on shared interests and group people into communities to foster closer connections.

## Project Structure

```
RoundUp/
├── backend/           # Python/FastAPI backend
└── RoundUp/          # iOS SwiftUI frontend
```

## Features

- User authentication and profile management
- Interest-based friend recommendations
- Group creation and management
- Real-time chat
- ML-powered friend matching

## Tech Stack

### Frontend (iOS)
- SwiftUI for UI
- Supabase Swift SDK for data management
- Swift Package Manager for dependencies

### Backend (Python)
- FastAPI for API endpoints
- Supabase for data storage
- NLTK and scikit-learn for recommendations
- PostgreSQL database (via Supabase)

## Setup

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Copy environment file and fill in your values:
```bash
cp .env.example .env
```

5. Run the server:
```bash
uvicorn app.main:app --reload
```

### Frontend Setup

1. Open Xcode project:
```bash
cd RoundUp
open RoundUp.xcodeproj
```

2. Install Swift package dependencies:
   - File > Add Packages
   - Add: https://github.com/supabase-community/supabase-swift.git

3. Copy environment file and fill in your values:
```bash
cp .env.example .env
```

4. Run the app in Xcode

## Environment Setup

You'll need to set up a Supabase project and add the following environment variables:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SECRET_KEY=your_backend_secret_key
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 