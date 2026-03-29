#!/bin/bash
# Setup script for Recipe MCP Server
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

echo ""
echo "========================================="
echo "Setup complete!"
echo "========================================="
echo ""
echo "Restart Claude Desktop to load the recipe_mcp server."
echo ""
echo "Python path for config: $(pwd)/venv/bin/python"
echo "Server path: $(pwd)/server.py"
