# Full-Stack Development Shell
# Copy this file as shell.nix to your full-stack project root
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Frontend - Node.js ecosystem
    nodejs_22
    nodePackages.pnpm
    # nodePackages.typescript  # Install via npm to avoid collision with gemini-cli
    # nodePackages.typescript-language-server  # Install via npm when needed
    # nodePackages.prettier  # Install via npm to avoid collision with gemini-cli
    nodePackages.eslint
    
    # Backend - Choose your stack
    # Go backend
    go
    gopls
    golangci-lint
    go-migrate
    
    # OR Python backend
    # python312
    # python312Packages.pip
    # python312Packages.virtualenv
    # poetry
    # python312Packages.fastapi
    # python312Packages.uvicorn
    
    # Database tools
    postgresql_16
    redis
    mongodb-tools
    pgcli
    
    # Database migrations
    flyway
    # sqlc              # Type-safe SQL for Go
    # python312Packages.alembic  # For Python
    
    # API development
    httpie             # HTTP client
    grpcurl            # gRPC testing
    protobuf           # Protocol buffers
    buf                # Better protobuf tooling
    
    # Documentation
    # swagger-codegen   # OpenAPI code generation
    
    # Infrastructure
    docker
    docker-compose
    
    # Cloud/deployment (uncomment as needed)
    # kubectl
    # kubernetes-helm
    # terraform
    # awscli2
    # google-cloud-sdk
    
    # Monitoring/debugging
    # prometheus
    # grafana
    
    # Message queues (if needed)
    # kafka
    # rabbitmq-server
    # nats-server
    
    # Development utilities
    jq                 # JSON processing
    yq                 # YAML processing
    watchexec          # File watcher
    entr               # Another file watcher
    tmux               # Terminal multiplexer
    
    # Testing tools
    # k6                # Load testing
    # cypress           # E2E testing
    # playwright-driver # Browser automation
  ];

  shellHook = ''
    echo "Full-Stack Development Environment"
    echo "================================"
    echo "Frontend: Node $(node --version)"
    echo "Backend: $(go version 2>/dev/null || python --version 2>/dev/null || echo 'Configure backend')"
    echo "Database: PostgreSQL ${pkgs.postgresql_16.version}"
    echo ""
    
    # Frontend setup
    if [ -f package.json ]; then
      if [ ! -d node_modules ]; then
        echo "Installing frontend dependencies..."
        pnpm install || npm install
      fi
    fi
    
    # Backend setup (Go)
    if [ -f go.mod ]; then
      echo "Setting up Go backend..."
      export GOPATH="$HOME/go"
      export PATH="$GOPATH/bin:$PATH"
      go mod download
    fi
    
    # Backend setup (Python)
    if [ -f requirements.txt ] || [ -f pyproject.toml ]; then
      echo "Setting up Python backend..."
      if [ ! -d .venv ]; then
        python -m venv .venv
      fi
      source .venv/bin/activate
      pip install --upgrade pip
      [ -f requirements.txt ] && pip install -r requirements.txt
      [ -f pyproject.toml ] && poetry install
    fi
    
    # Docker check
    if [ -f docker-compose.yml ] || [ -f docker-compose.yaml ]; then
      echo ""
      echo "Docker Compose file found. Services available:"
      echo "  docker-compose up    - Start all services"
      echo "  docker-compose down  - Stop all services"
    fi
    
    # Environment variables notice
    if [ -f .env.example ]; then
      if [ ! -f .env ]; then
        echo ""
        echo "Creating .env from .env.example..."
        cp .env.example .env
        echo "Please update .env with your local settings"
      fi
    fi
    
    echo ""
    echo "Ready for development!"
  '';
  
  # Environment variables
  NODE_ENV = "development";
  
  # Backend ports
  API_PORT = "8080";
  FRONTEND_PORT = "3000";
  
  # Database connections
  DATABASE_URL = "postgresql://dom:devpass@localhost/devdb";
  REDIS_URL = "redis://localhost:6379";
  
  # Development settings
  CGO_ENABLED = "1";  # For Go
  PYTHONDONTWRITEBYTECODE = "1";  # For Python
  PYTHONUNBUFFERED = "1";  # For Python
  
  # Docker
  DOCKER_BUILDKIT = "1";
  COMPOSE_DOCKER_CLI_BUILD = "1";
}