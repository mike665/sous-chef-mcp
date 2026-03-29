# Sous Chef MCP

A local MCP server for Claude Desktop that eliminates shopping list hallucinations by extracting recipe data directly from structured schema.org markup. No more phantom Thai peppers.

## The Problem

When you ask Claude to build a weekly menu and shopping list from recipe websites, it reads the page content and reconstructs the ingredient list from memory. This leads to hallucinated ingredients that don't appear in the actual recipe, missed items, and incorrect quantities. The shopping list looks right but doesn't match what the recipes actually call for.

## The Fix

Almost every major recipe website embeds structured JSON-LD data using the [schema.org Recipe](https://schema.org/Recipe) type (Google requires it for rich search results). Sous Chef MCP extracts this structured data directly, giving you the exact ingredient list the recipe author published. The shopping list is built from verified data, not Claude's interpretation.

## Features

- **Verified ingredient extraction** from any recipe site using schema.org JSON-LD (site-agnostic, no per-site scraping)
- **Categorized shopping lists** grouped by store section: Protein, Dairy, Produce, Dry Goods, Frozen, Bread & Bakery
- **Recipe attribution** on every ingredient so you know which recipe needs what
- **Pantry staples management** for ingredients you always have on hand (listed separately as "verify stock")
- **Cook and prep time tracking** with timing info on the menu to help plan around long-prep meals
- **Favorites and history** to track what you've made, save winners, and avoid repeats
- **Exclusion list** for recipes or ingredients you don't like
- **Apple Notes formatting** with your preferred layout, ready for direct export
- **Configurable site discovery** with search patterns and category URLs for your favorite recipe sites
- **Add new sites on the fly** either by editing config or asking Claude during a conversation

## Quick Start

```bash
# Clone and set up
git clone https://github.com/Mike665/sous-chef-mcp.git
cd sous-chef-mcp
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "recipe_mcp": {
      "command": "/path/to/sous-chef-mcp/venv/bin/python",
      "args": ["/path/to/sous-chef-mcp/server.py"]
    }
  }
}
```

Restart Claude Desktop.

## Tools

| Tool | Description |
|------|-------------|
| `recipe_get` | Extract structured recipe data from any URL |
| `recipe_build_shopping_list` | Aggregate multiple recipes into a categorized shopping list |
| `recipe_format_menu` | Format a full weekly menu + shopping list for Apple Notes |
| `recipe_add_site` | Add a new recipe website to the discovery config |
| `recipe_list_sites` | List all configured recipe sites |
| `recipe_add_favorite` | Save a recipe to favorites with tags |
| `recipe_remove_favorite` | Remove a recipe from favorites |
| `recipe_list_favorites` | List all favorited recipes |
| `recipe_add_exclusion` | Block a recipe or ingredient |
| `recipe_remove_exclusion` | Unblock a recipe or ingredient |
| `recipe_list_exclusions` | List all exclusions |
| `recipe_manage_pantry` | Add/remove pantry staple items |
| `recipe_list_pantry` | List current pantry staples |
| `recipe_get_history` | View recently used recipes with dates and use counts |

## Example Workflow

```
You: I need a menu for 5 days: 1 vegetarian, 1 fish, only 1 red meat.
     Browse skinnytaste and halfbakedharvest for options.
     Check my history to avoid repeats.
     Build the Apple Notes output with "hand soap" as an extra item.

Claude: [browses sites, picks recipes matching constraints]
        [calls recipe_get on each URL for verified ingredients]
        [calls recipe_format_menu to build formatted output]
        [exports to Apple Notes via connector]
```

## Configuration

### config/sites.yaml

Recipe site configurations for discovery. Each site can have a base URL, search URL pattern, and category paths. Adding a site here enables Claude to browse it by category. You do NOT need to add a site here just to extract a recipe from a URL.

Pre-configured sites: Skinnytaste, Half Baked Harvest, Chelsea's Messy Apron, Real Food Whole Life, Damn Delicious, Cucina by Elena.

### config/pantry_staples.yaml

Ingredients you always keep stocked. These still appear on the shopping list but in a separate "Pantry Staples (verify stock)" section. Edit directly or use the `recipe_manage_pantry` tool.

### data/ (auto-generated)

- `favorites.json` - Saved favorite recipes with tags
- `exclusions.json` - Blocked recipes and ingredients with reasons
- `history.json` - Auto-populated log of every recipe fetched

## How JSON-LD Extraction Works

Recipe websites embed structured data in their HTML for Google rich search results. The server extracts this directly, which includes:

- `recipeIngredient` - exact ingredient list with quantities
- `prepTime` / `cookTime` / `totalTime` - ISO 8601 durations
- `recipeYield` - serving size
- `recipeInstructions` - step-by-step directions
- `recipeCategory`, `recipeCuisine`, `keywords` - metadata

This means the shopping list is built from exactly what the recipe author published, not from Claude's interpretation of the page text. If an ingredient isn't in the recipe's structured data, it won't appear on your shopping list.

## Requirements

- Python 3.10+
- Claude Desktop with MCP support

## License

MIT
