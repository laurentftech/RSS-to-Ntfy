# RSS-to-Ntfy

# Overview
A simple python based script that monitors RSS feeds and sends new posts as notifications through Ntfy. 

## 🌟 Features
- 🔄 Real-time RSS feed monitoring
- 📱 Push notifications via Ntfy
- 🔐 Authentication support for private Ntfy servers
- 🖼️ Image attachment support
- 🏷️ Tag handling
- 📝 Smart description truncation
- 🔁 Retry mechanism for failed notifications
- 📋 Last seen post tracking
- 📊 Comprehensive logging


## Requirements
- Python 3.7+ (or Docker)
- RSS feed URL (e.g.: FreshRSS instance)
- Ntfy channel

# Installation
1. Clone the repository
```
git clone https://github.com/kasun-97/RSS-to-Ntfy
cd RSS-to-Ntfy
```

2. Create a virtual environment (optional but recommended)
```
python3 -m venv venv
source venv/bin/activate # On Windows: venv\Scripts\activate
```

3. Install required packages
```
pip install -r requirements.txt
```

## Usage

### 1. Configure Environment Variables

Create a `.env` file in the project directory with the following variables:

**For public Ntfy servers (ntfy.sh):**
```bash
RSS_URL=https://your-freshrss-instance/api/feed.php
NTFY_CHANNEL=https://ntfy.sh/your-channel
```

**For private/self-hosted Ntfy servers:**
```bash
RSS_URL=https://your-freshrss-instance/api/feed.php
NTFY_CHANNEL=https://your-ntfy-server.com/your-channel
NTFY_TOKEN=tk_your_access_token_here
```

#### How to get a Ntfy access token:

1. **Using the Ntfy CLI (recommended):**
   ```bash
   ntfy token add rssbot --topic your-channel --write
   ```
   This creates a token named "rssbot" with write permissions for your channel. The command will output the token that starts with `tk_`.

2. **Using the Ntfy web interface:**
   - Go to your Ntfy server (e.g., `https://your-ntfy-server.com`)
   - Click on "Account" or the user icon
   - Navigate to "Access Tokens"
   - Click "Create access token"
   - Give it a name (e.g., "RSS-to-Ntfy")
   - Select the topic/channel and grant write permissions
   - Copy the generated token (starts with `tk_`)

3. **Using curl (API):**
   ```bash
   curl -u username:password https://your-ntfy-server.com/v1/account/token \
     -d '{"label":"RSS-to-Ntfy","expires":0}'
   ```

**Note:** The token is only required if your Ntfy server/channel requires authentication. For public channels on ntfy.sh, you can omit the `NTFY_TOKEN` variable.

### 2. Run the script
```
python3 ./rss-to-ntfy.py
```

### 3. (Optional) Set up as a scheduled task
   - If you are not using a virtual environment:
     ```
     */5 * * * * /path/to/python /path/to/rss-to-ntfy.py
     ```

    - If you are using a virtual environment, create a shell script (e.g., `run_rss_notifier.sh`):
      
      ```
      #!/bin/bash 
      
      # Set path to your project
      PROJECT_DIR="/path/to/your/project" 
      
      # Activate virtual environment and run script
      source $PROJECT_DIR/venv/bin/activate 
      python3 $PROJECT_DIR/rss-to-ntfy.py
      
      # Deactivate virtual environment
      deactivate
      ```
      
      Make it executable:
      
      ```
      chmod +x run_rss_notifier.sh
      ```
      
      Add to crontab:
      
      ```
      # Run every 5 minutes 
      */5 * * * * /path/to/your/project/run_rss_notifier.sh >> /path/to/your/project/cron.log 2>&1
      ```

## Docker Usage

### Using Docker Compose (Recommended)

1. Create a `.env` file with your configuration (see Configuration Options below)

2. Add to your `docker-compose.yml`:
```yaml
services:
  rss-to-ntfy:
    build: ./RSS-to-Ntfy
    container_name: rss-to-ntfy
    restart: unless-stopped
    volumes:
      - ./state:/app/state
    env_file:
      - .env
```

3. Start the service:
```bash
docker-compose up -d rss-to-ntfy
```

### Using Docker CLI

```bash
# Build the image
docker build -t rss-to-ntfy .

# Run the container
docker run -d \
  --name rss-to-ntfy \
  --restart unless-stopped \
  -v $(pwd)/state:/app/state \
  --env-file .env \
  rss-to-ntfy
```

## Configuration Options
The script can be configured through environment variables or by modifying the `Config` class:

| Parameter | Description | Default |
|-----------|-------------|---------|
| RSS_URL | Your RSS feed URL | None |
| NTFY_CHANNEL | Your Ntfy channel URL | None |
| NTFY_TOKEN | Authentication token for private ntfy servers (optional) | None |
| POLL_INTERVAL | Interval in seconds between RSS feed checks | 300 (5 min) |
| MAX_DESCRIPTION_LENGTH | Maximum length for truncated descriptions | 250 |
| REQUEST_TIMEOUT | Timeout for HTTP requests (seconds) | 10 |
| RETRY_ATTEMPTS | Number of retry attempts for failed notifications | 3 |
| RETRY_DELAY | Delay between retry attempts (seconds) | 2 |
| MAX_ENTRIES | Maximum number of entries to process at once | 50 |


## Logging
The script generates logs in `rss_notifier.log` with the following information:
- Script start/stop times
- Successful notifications
- Error messages
- Processing statistics

## Acknowledgments

- [FreshRSS](https://freshrss.org/) for RSS feed management
- [Ntfy](https://ntfy.sh/) for notification delivery
- All contributors and users of this project
