# Python Development Shell
# Copy this file as shell.nix to your Python project root
{ pkgs ? import <nixpkgs> {} }:

let
  # Define Python version and packages
  python = pkgs.python312;
  pythonPackages = python.pkgs;
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python and package management
    python
    pythonPackages.pip
    pythonPackages.virtualenv
    poetry              # Modern dependency management
    pythonPackages.uv   # Fast package installer
    
    # Development tools
    pythonPackages.ipython      # Enhanced REPL
    pythonPackages.jupyter      # Jupyter notebooks
    pythonPackages.jupyterlab   # JupyterLab
    
    # Code quality tools
    pythonPackages.black        # Code formatter
    pythonPackages.isort        # Import sorter
    pythonPackages.flake8       # Linter
    pythonPackages.pylint       # Another linter
    pythonPackages.mypy         # Type checker
    pythonPackages.bandit       # Security linter
    ruff                        # Fast Python linter
    
    # Testing
    pythonPackages.pytest       # Testing framework
    pythonPackages.pytest-cov   # Coverage plugin
    pythonPackages.pytest-mock  # Mocking support
    pythonPackages.pytest-asyncio # Async support
    pythonPackages.tox          # Test automation
    pythonPackages.hypothesis   # Property-based testing
    
    # Documentation
    pythonPackages.sphinx       # Documentation generator
    pythonPackages.mkdocs       # Another doc generator
    
    # Common libraries (add as needed)
    # pythonPackages.numpy
    # pythonPackages.pandas
    # pythonPackages.matplotlib
    # pythonPackages.scipy
    # pythonPackages.scikit-learn
    # pythonPackages.tensorflow
    # pythonPackages.torch
    
    # Web frameworks (uncomment as needed)
    # pythonPackages.django
    # pythonPackages.flask
    # pythonPackages.fastapi
    # pythonPackages.uvicorn
    
    # Database libraries
    # pythonPackages.psycopg2    # PostgreSQL
    # pythonPackages.sqlalchemy   # ORM
    # pythonPackages.alembic      # Migrations
    # pythonPackages.redis        # Redis client
    
    # API/HTTP tools
    # pythonPackages.requests
    # pythonPackages.httpx
    # pythonPackages.aiohttp
    
    # Data tools
    # pythonPackages.pydantic     # Data validation
    # pythonPackages.marshmallow  # Serialization
    
    # Additional tools
    # docker
    # docker-compose
    # postgresql_16
    # redis
  ];

  shellHook = ''
    echo "Python Development Environment"
    echo "Python $(python --version)"
    
    # Create virtual environment if it doesn't exist
    if [ ! -d .venv ]; then
      echo "Creating virtual environment..."
      python -m venv .venv
    fi
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install dependencies
    if [ -f requirements.txt ]; then
      echo "Installing requirements.txt..."
      pip install -r requirements.txt
    elif [ -f pyproject.toml ]; then
      echo "Found pyproject.toml"
      if command -v poetry &> /dev/null; then
        echo "Installing with poetry..."
        poetry install
      else
        echo "Installing with pip..."
        pip install -e .
      fi
    fi
    
    # Set Python path
    export PYTHONPATH="$PWD:$PYTHONPATH"
    
    # Development settings
    export PYTHONDONTWRITEBYTECODE=1
    export PYTHONUNBUFFERED=1
    
    echo ""
    echo "Virtual environment activated. Use 'deactivate' to exit."
  '';
  
  # Environment variables
  PYTHONDONTWRITEBYTECODE = "1";
  PYTHONUNBUFFERED = "1";
  
  # Database URLs (adjust as needed)
  # DATABASE_URL = "postgresql://dom:devpass@localhost/devdb";
  # REDIS_URL = "redis://localhost:6379";
}