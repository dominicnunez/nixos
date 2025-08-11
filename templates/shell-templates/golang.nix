# Go Development Shell
# Copy this file as shell.nix to your Go project root
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Go - choose your version
    go  # Latest stable
    # go_1_23
    # go_1_22
    # go_1_21
    
    # Go development tools
    gopls              # Go language server
    gotools            # Go tools (goimports, etc.)
    go-outline         # Go code outline
    gomodifytags       # Modify struct tags
    gotests            # Generate tests
    gocode-gomod       # Autocomplete daemon
    
    # Code quality tools
    golangci-lint      # Meta linter
    govulncheck        # Vulnerability checker
    go-tools           # Additional tools (staticcheck, etc.)
    
    # Debugging and profiling
    delve              # Debugger
    gore               # REPL
    graphviz           # For pprof graphs
    
    # Database tools (if needed)
    # go-migrate        # Database migrations
    # sqlc              # Generate type-safe Go from SQL
    
    # API development
    # grpcurl           # gRPC testing
    # protobuf          # Protocol buffers
    # protoc-gen-go     # Protobuf Go generator
    # protoc-gen-go-grpc # gRPC Go generator
    # buf               # Protocol buffer tool
    
    # Testing tools
    # gotestsum         # Better test output
    # ginkgo            # BDD testing framework
    # mockgen           # Mock generator
    
    # Build tools
    # goreleaser        # Release automation
    # ko                # Container builder for Go
    # mage              # Build tool
    
    # Additional tools
    # air               # Live reload
    # docker
    # docker-compose
    # kubernetes-helm
    # kubectl
  ];

  shellHook = ''
    echo "Go Development Environment"
    go version
    
    # Set up Go environment
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
    
    # Enable Go modules
    export GO111MODULE=on
    export GOPROXY="https://proxy.golang.org,direct"
    export GOSUMDB="sum.golang.org"
    
    # Development settings
    export CGO_ENABLED=1
    export GOFLAGS="-mod=readonly"
    
    # Initialize go.mod if it doesn't exist
    if [ ! -f go.mod ]; then
      echo "No go.mod found. Run 'go mod init <module-name>' to initialize."
    else
      echo "Downloading dependencies..."
      go mod download
    fi
    
    # Create common directories
    mkdir -p bin pkg
  '';
  
  # Environment variables
  GOPATH = "$HOME/go";
  CGO_ENABLED = "1";
  
  # Development database URLs (adjust as needed)
  # DATABASE_URL = "postgres://localhost/devdb?sslmode=disable";
  # REDIS_URL = "redis://localhost:6379";
}