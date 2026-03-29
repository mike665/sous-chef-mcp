#!/bin/bash
# Setup script for Sous Chef MCP Server
# Run this once: cd ~/MCP/recipe-mcp && bash setup.sh

set -e

echo "Creating Python virtual environment..."
python3 -m venv venv

echo "Installing dependencies..."
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt

echo ""
echo "Verifying installation..."
./venv/bin/python -c "
from mcp.server.fastmcp import FastMCP
import httpx
from bs4 import BeautifulSoup
import yaml
print('All imports successful')
"

echo ""
echo "Verifying server compiles..."
./venv/bin/python -m py_compile server.py
echo "Server compilation OK"

# Create default pantry staples if missing
if [ ! -f config/pantry_staples.yaml ]; then
    echo ""
    echo "Creating default pantry staples..."
    mkdir -p config
    cat > config/pantry_staples.yaml << 'PANTRY'
staples:
  - salt
  - black pepper
  - olive oil
  - vegetable oil
  - cooking spray
  - garlic
  - all-purpose flour
  - sugar
  - brown sugar
  - baking powder
  - baking soda
  - vanilla extract
  - soy sauce
  - apple cider vinegar
  - red wine vinegar
  - white vinegar
  - dried oregano
  - dried basil
  - cumin
  - paprika
  - chili powder
  - garlic powder
  - onion powder
  - crushed red pepper
  - bay leaves
  - cinnamon
  - Italian seasoning
  - cayenne
  - cornstarch
PANTRY
    echo "Default pantry staples created. Edit config/pantry_staples.yaml or use the recipe_manage_pantry tool to customize."
fi

# Create data directory
mkdir -p data

# Check for gh CLI
if command -v gh &> /dev/null; then
    if gh auth status &> /dev/null 2>&1; then
        echo ""
        echo "GitHub CLI: authenticated"
    else
        echo ""
        echo "GitHub CLI: installed but not authenticated"
        echo "  Run 'gh auth login' to enable feedback and self-update features"
    fi
else
    echo ""
    echo "GitHub CLI: not installed (optional)"
    echo "  Install with 'brew install gh' to enable feedback and self-update features"
fi

echo ""
echo "========================================="
echo "Setup complete!"
echo "========================================="
echo ""
echo "Add this to your Claude Desktop config:"
echo "  ~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""
echo "  {\"mcpServers\": {\"sous_chef\": {"
echo "    \"command\": \"$(pwd)/venv/bin/python\","
echo "    \"args\": [\"$(pwd)/server.py\"]"
echo "  }}}"
echo ""
echo "Then restart Claude Desktop."
