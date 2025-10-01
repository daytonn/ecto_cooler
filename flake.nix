{
  description = "EctoCooler - Elixir Application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Elixir and Erlang versions - using latest stable that work together
        elixir = pkgs.elixir;
        erlang = pkgs.erlang;
        
        
        # Development convenience script
        dev-setup = pkgs.writeShellScriptBin "dev-setup" ''
          echo "Setting up development environment..."
          mix deps.get
          echo "Development environment ready!"
        '';
        
        # Test runner script
        test-runner = pkgs.writeShellScriptBin "test-runner" ''
          echo "Running tests..."
          mix test
        '';
        
      in {
        devShells = {
          default = pkgs.mkShell {
            name = "scpc";
            buildInputs = with pkgs; [
              # Core Elixir/Erlang
              elixir
              erlang

              # Development tools
              git

              # Build tools
              gcc
              gnumake

              # Convenience scripts
              dev-setup
              test-runner
            ];

            shellHook = ''
              set -euo pipefail

              # Prevent crashes from version commands
              trap 'echo "⚠️  Error in shell hook, continuing..." 2>/dev/null || true' ERR

              # Color codes for better output
              RED='\033[0;31m'
              GREEN='\033[0;32m'
              YELLOW='\033[1;33m'
              BLUE='\033[0;34m'
              PURPLE='\033[0;35m'
              CYAN='\033[0;36m'
              NC='\033[0m' # No Color

              echo -e "''${PURPLE}🐘 EctoCooler - Development Environment''${NC}"
              echo -e "''${PURPLE}==================================================''${NC}"
              echo ""
              echo -e "''${CYAN}Available commands:''${NC}"
              echo -e "  ''${GREEN}dev-setup''${NC}        - Set up the development environment"
              echo -e "  ''${GREEN}test-runner''${NC}      - Run the test suite"
              echo ""
              echo -e "''${CYAN}Environment:''${NC}"
              echo -e "  ''${YELLOW}Elixir:''${NC} Available"
              echo -e "  ''${YELLOW}Erlang:''${NC} Available"
              echo ""

              # Set up environment variables
              export MIX_ENV=dev
              export ERL_AFLAGS="-kernel shell_history enabled"

              # Ensure we're using the right Elixir version
              export PATH="${elixir}/bin:$PATH"
              export PATH="${erlang}/bin:$PATH"
            '';

            # Environment variables for the shell
            ERL_AFLAGS = "-kernel shell_history enabled";
            MIX_ENV = "dev";

            # Make sure Elixir can find Erlang
            ERL_LIBS = "${erlang}/lib/erlang/lib";
          };

          # Testing shell with additional test tools
          test = pkgs.mkShell {
            name = "wise-ones-tower-test";
            buildInputs = with pkgs; [
              elixir
              erlang
              git
              gcc
              gnumake
            ];
            shellHook = ''
              echo "🧪 EctoCooler - Testing Environment"
              echo "Optimized for running tests and CI"
            '';
            ERL_LIBS = "${erlang}/lib/erlang/lib";
          };
        };
      }
    );
} 
