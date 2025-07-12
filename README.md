# Voting Platform

A modern ranked choice voting platform built with Ruby on Rails, featuring Instant Runoff Voting (IRV) with delegation capabilities.

## Features

- **Ranked Choice Voting**: Users rank candidates in order of preference
- **Instant Runoff Voting**: Automatic winner determination using IRV algorithm
- **Delegation System**: Users can delegate their vote to trusted individuals
- **Real-time Results**: Live election results with round-by-round breakdown
- **Mobile-Friendly**: Responsive design with touch-friendly drag-and-drop
- **Admin Dashboard**: Create and manage elections and candidates
- **Export Options**: Results available in CSV and JSON formats

## Technology Stack

- **Backend**: Ruby on Rails 7.2
- **Database**: PostgreSQL
- **Frontend**: HTML, CSS, JavaScript with Stimulus.js
- **Drag & Drop**: Sortable.js
- **Server**: Puma
- **Deployment**: Render (configured)

## Prerequisites

- Ruby 3.0 or higher
- PostgreSQL
- Node.js (for asset compilation)

## Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd voting_platform
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Visit the application**
   Open http://localhost:3000 in your browser

## Usage

### For Voters

1. **Register**: Create an account with email and password
2. **Browse Elections**: View available elections on the home page
3. **Vote**: Click "Vote" on an election to access the ballot
4. **Rank Candidates**: Drag and drop candidates to rank them (top = most preferred)
5. **Submit**: Click "Submit Ballot" to cast your vote
6. **View Results**: Check real-time results and see the winner

### For Administrators

1. **Access Admin**: Go to `/admin/elections`
2. **Create Election**: Set title, description, and timing
3. **Add Candidates**: Add candidates to the election
4. **Monitor**: View results and manage the election

### Delegation System

1. **Set Delegate**: Choose someone to vote on your behalf
2. **Chain Delegations**: Delegations can form chains (A → B → C)
3. **Automatic Calculation**: Vote weights are calculated automatically

## Development

### Running Tests
```bash
rails test
```

### Code Quality
```bash
bundle exec rubocop
bundle exec brakeman
```

### Database Reset
```bash
rails db:reset
```

## Deployment

This application is configured for deployment on Render. See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions.

### Quick Deploy to Render

1. Push your code to a Git repository
2. Connect your repository to Render
3. Use the provided `render.yaml` for automatic setup
4. Set the `RAILS_MASTER_KEY` environment variable
5. Deploy!

## Project Structure

```
app/
├── controllers/          # Rails controllers
│   ├── admin/           # Admin controllers
│   ├── elections_controller.rb
│   └── users_controller.rb
├── models/              # ActiveRecord models
│   ├── election.rb      # Core voting logic
│   ├── candidate.rb
│   ├── ranked_ballot.rb
│   └── delegation.rb
├── views/               # ERB templates
│   ├── elections/       # Voting interface
│   ├── admin/          # Admin interface
│   └── layouts/
└── javascript/         # Stimulus controllers
    └── controllers/
        └── sortable_controller.js  # Drag & drop functionality

config/
├── routes.rb           # Application routes
├── database.yml        # Database configuration
└── environments/       # Environment-specific configs

bin/
└── render-build.sh     # Render deployment script
```

## Voting Algorithm

The platform uses **Instant Runoff Voting (IRV)**:

1. **Count First Choices**: Count all voters' first-choice candidates
2. **Check for Winner**: If a candidate has >50% of votes, they win
3. **Eliminate Last Place**: Remove the candidate with the fewest votes
4. **Redistribute Votes**: Move eliminated candidates' votes to next preferences
5. **Repeat**: Continue until a winner is determined

### Delegation Resolution

1. **Build Delegation Map**: Resolve all delegation chains
2. **Calculate Vote Weights**: Each user's final vote weight
3. **Apply Weights**: Use weighted votes in IRV calculation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For deployment issues, see [DEPLOYMENT.md](DEPLOYMENT.md).
For general questions, please open an issue on GitHub.
