<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

## Comprehensive Dynamic Reference for Perplexity Terminal Development

Here's a structured guide with ideas, instructions, links, and references for developing a terminal-based working environment for Perplexity.[^1][^2][^3]

## API Access \& Authentication

Perplexity offers two main API platforms: the **Search API** for programmatic access to web retrieval infrastructure, and **Sonar** models for fast, web-grounded responses with citations. Access the API through Settings → "</> API" tab to generate keys, add credits, and monitor usage. Pro subscribers receive \$5 in monthly API credits.[^2][^3][^4]

Set your API key as an environment variable:

```bash
# MacOS/Linux
export PERPLEXITY_API_KEY="your_api_key_here"

# Windows
setx PERPLEXITY_API_KEY "your_api_key_here"
```


## Terminal CLI Tools

### Perplexity-CLI

A Python-based command-line client with rich features:[^5]

**Installation:**

```bash
curl -s https://raw.githubusercontent.com/dawid-szewc/perplexity-cli/main/perplexity.py > ~/.local/bin/perplexity
chmod +x ~/.local/bin/perplexity
echo 'export PERPLEXITY_API_KEY="your-api-key"' >> ~/.bashrc
```

**Usage:**

```bash
# Basic query
perplexity "What is the meaning of life?"

# With options
perplexity -uc -m sonar-pro "Explain Einstein's theory of relativity"
```

**Key features:**

- Token usage statistics (`-u`)
- Citation display (`-c`)
- Multiple model support (`-m`)
- Colorful output with Glow formatting (`-g`)


### LLM Tool Integration

Simon Willison's `llm` command-line utility provides comprehensive access to Perplexity models:[^6]

**Installation:**

```bash
uv tool install llm
llm install llm-perplexity
```

**Configuration:**

```bash
llm keys set perplexity
# Paste your API key when prompted
```

All Sonar models include Perplexity's search integration built-in.[^6]

## Model Context Protocol (MCP) Integration

MCP enables secure connections between Perplexity and external data sources, tools, and services. This protocol is essential for terminal-based workflows.[^1]

### Local MCP Setup (MacOS)

**Installation steps:**

1. Open Settings → Connectors
2. Install PerplexityXPC helper application
3. Add MCP Connector via "Simple" tab
4. Configure server name and launch command
5. Wait for "Running" status
6. Toggle MCP on under "Sources"

### Useful Terminal-Focused MCPs

**Filesystem Access**

- Access local directories, read/search files
- Repository: github.com/modelcontextprotocol/servers

**iTerm Integration**

- Control iTerm 2 with natural language from Perplexity
- Repository: github.com/ferrislucas/iterm-mcp

**Apple MCP Tools**

- Create reminders, calendar events, send emails
- Repository: github.com/supermemoryai/apple-mcp

**Apple Notes**

- Search and edit Apple Notes from terminal
- Repository: github.com/RafalWilinski/mcp-apple-notes

**Example configuration:**

```bash
# Install Node.js requirement
brew install node

# Add MCP command
npx -y @peakmojo/applescript-mcp
```


## SDK Development

### Python SDK

```python
from perplexity import Perplexity

client = Perplexity()

response = client.responses.create(
    preset="fast-search",
    input="Tell me about the James Webb Space Telescope discoveries.",
    instructions="You are a helpful assistant.",
    tools=[{
        "type": "web_search",
        "filters": {
            "search_domain_filter": ["nasa.gov", "wikipedia.org"]
        }
    }]
)

print(response.output_text)
```


### cURL Integration

```bash
curl https://api.perplexity.ai/v1/responses \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openai/gpt-5-mini",
    "input": "Your query here"
  }'
```


## Key Resources

### Official Documentation

- **API Platform**: Main developer portal[^7]
- **SDK Overview**: Python \& TypeScript guides[^8]
- **Help Center**: Complete knowledge base[^9]


### MCP Resources

- **MCP Documentation**: Official protocol guide[^10]
- **Build MCP Servers**: Server development tutorial[^11]
- **Connect Local Servers**: Setup guide for local MCP[^10]


### Community Tools

- **Perplexity CLI GitHub**: Open-source terminal client
- **Constantin Gonzalez's Guide**: Terminal integration walkthrough
- **MCP Integration Guide**: Comprehensive AI integration tutorial


## Improvement Ideas

**Terminal workflow enhancements:**

- Create custom shell aliases for frequent queries
- Build script pipelines combining MCP filesystem access with Perplexity queries
- Develop tmux/screen layouts optimized for Perplexity terminal sessions
- Integrate with terminal-based note-taking systems (Obsidian CLI, Joplin)

**Automation opportunities:**

- Cron jobs for scheduled research queries
- Git hooks that query Perplexity for commit message suggestions
- Terminal-based bookmarking system with Perplexity summarization
- Custom MCP servers for domain-specific terminal tools

**Security considerations:**

- Always verify open-source MCP servers before installation[^1]
- Use environment variables for API keys (never hardcode)
- Implement rate limiting for automated queries
- Review MCP server permissions carefully

This reference provides a foundation for building sophisticated terminal-based Perplexity workflows. The combination of CLI tools, MCP integration, and SDK access enables powerful automation and seamless integration with existing terminal environments.[^3][^13][^2]
<span style="display:none">[^12][^14][^15][^16][^17][^18][^19][^20][^21][^22][^23][^24][^25]</span>

<div align="center">⁂</div>

[^1]: https://www.perplexity.ai/help-center/en/articles/11502712-local-and-remote-mcps-for-perplexity

[^2]: https://www.perplexity.ai/help-center/en/articles/10352995-api-settings

[^3]: https://www.perplexity.ai/help-center/en/articles/10354842-what-is-the-perplexity-api-platform

[^4]: https://www.perplexity.ai/help-center/en/articles/10354847-api-payment-and-billing

[^5]: https://github.com/dawid-szewc/perplexity-cli

[^6]: https://constantin.glez.de/notes/2025-07-10-using-perplexity-from-the-command-line-via-llm/

[^7]: https://www.perplexity.ai/api-platform

[^8]: https://docs.perplexity.ai/docs/sdk/overview

[^9]: https://www.perplexity.ai/help-center/en/

[^10]: https://modelcontextprotocol.io/docs/develop/connect-local-servers

[^11]: https://modelcontextprotocol.io/docs/develop/build-server

[^12]: https://wandb.ai/byyoung3/Generative-AI/reports/The-Model-Context-Protocol-MCP-A-guide-for-AI-integration--VmlldzoxMTgzNDgxOQ

[^13]: https://docs.perplexity.ai/docs/getting-started/overview

[^14]: https://www.perplexity.ai/hub/blog/introducing-the-perplexity-search-api

[^15]: https://www.perplexity.ai/hub/getting-started

[^16]: https://www.perplexity.ai/help-center/en/articles/13529668-comet-policies-and-controls

[^17]: https://www.perplexity.ai/hub/blog/introducing-pplx-api

[^18]: https://www.perplexity.ai/hub/blog/introducing-the-sonar-pro-api

[^19]: https://www.reddit.com/r/perplexity_ai/comments/1oq623d/how_to_use_perplexity_and_its_models_in_cli/

[^20]: https://docs.perplexity.ai/llms-full.txt

[^21]: https://balaskas.gr/blog/2025/09/21/ai-notes-using-llm-perplexity-from-the-terminal/

[^22]: https://developers.openai.com/codex/mcp/

[^23]: https://docs.perplexity.ai

[^24]: https://apify.com/incredible_moment/perplexity-actor/api/cli

[^25]: https://www.typingmind.com/guide/use-perplexity-api-key-to-chat-with-ai

