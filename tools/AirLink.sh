
#!/usr/bin/env bash

# =============== Airlink Panel PRO Installer ===============
# Panel repo  : https://github.com/JishnuTheGamer/Air-link-panel.git  -> folder: panel
# Daemon repo : https://github.com/AirlinkLabs/daemon.git            -> folder: daemon

# ----------- UI / Colors (tput) -----------
RED=$(tput setaf 1 2>/dev/null || true)
GREEN=$(tput setaf 2 2>/dev/null || true)
YELLOW="$(tput bold 2>/dev/null || true)$(tput setaf 3 2>/dev/null || true)"
BLUE=$(tput setaf 4 2>/dev/null || true)
CYAN=$(tput setaf 6 2>/dev/null || true)
NC=$(tput sgr0 2>/dev/null || true)

LOG_FILE="${LOG_FILE:-$HOME/airlink-installer.log}"

# ----------- Logo -----------
logo() {
  clear
  printf "%s" "$BLUE"
  cat <<'ASCII'
  ____    _   _      _      ____     ___   __        __
/ ___|  | | | |    / \    |  _ \   / _ \  \ \      / /
\___ \  | |_| |   / _ \   | | | | | | | |  \ \ /\ / / 
 ___) | |  _  |  / ___ \  | |_| | | |_| |   \ V  V /  
|____/  |_| |_| /_/   \_\ |____/   \___/     \_/\_/
ASCII
  printf "%s\n" "${NC}${YELLOW}=========== Airlink Panel PRO BY ShadowCraftMC ===========${NC}"
  printf "%s\n\n" "${BLUE}Log file:${NC} $LOG_FILE"
}

pause() {
  printf "\n%sPress Enter to continue...%s" "$BLUE" "$NC"
  read -r _
}

# ----------- Progress Bar + dots -----------
BAR_WIDTH=28
TOTAL_STEPS=1
DONE_STEPS=0

progress_init() {
  TOTAL_STEPS="$1"
  DONE_STEPS=0
}

_progress_line() {
  local msg="$1"
  local dots="$2"

  local percent=$(( DONE_STEPS * 100 / TOTAL_STEPS ))
  local filled=$(( percent * BAR_WIDTH / 100 ))
  local empty=$(( BAR_WIDTH - filled ))

  local fillstr emptstr
  fillstr=$(printf "%${filled}s" | tr ' ' '#')
  emptstr=$(printf "%${empty}s"  | tr ' ' '-')

  printf "\r%s[%s%s] %3d%%%s %s%s%s" \
    "$CYAN" "$fillstr" "$emptstr" "$percent" "$NC" \
    "$YELLOW" "$msg" "$dots"
}

step_ok() {
  DONE_STEPS=$((DONE_STEPS + 1))
  _progress_line "$1" ""
  printf " %s✓%s\n" "$GREEN" "$NC"
}

step_fail() {
  printf "\n%sFailed:%s %s\n" "$RED" "$NC" "$1"
  printf "%sCheck log:%s %s\n" "$YELLOW" "$NC" "$LOG_FILE"
  return 1
}

step_skip() {
  DONE_STEPS=$((DONE_STEPS + 1))
  _progress_line "$1" " (skip)"
  printf " %s✓%s\n" "$GREEN" "$NC"
}

task() {
  local msg="$1"
  local cmd="$2"

  # Run cmd in background, log everything
  bash -c "set -o pipefail; $cmd" >>"$LOG_FILE" 2>&1 &
  local pid=$!

  local i=0 dots=""
  while kill -0 "$pid" 2>/dev/null; do
    case $i in
      0) dots="   " ;;
      1) dots=".  " ;;
      2) dots=".. " ;;
      3) dots="..." ;;
    esac
    _progress_line "$msg" " $dots"
    i=$(( (i + 1) % 4 ))
    sleep 0.35
  done

  wait "$pid"
  local rc=$?
  if [ $rc -ne 0 ]; then
    step_fail "$msg"
    return $rc
  fi

  step_ok "$msg"
  return 0
}

# ----------- Helpers -----------
need_sudo() {
  if [ "$(id -u)" -ne 0 ]; then
    if ! command -v sudo >/dev/null 2>&1; then
      printf "%sError:%s sudo not found. Run as root.\n" "$RED" "$NC"
      exit 1
    fi
  fi
}

confirm_reinstall_dir() {
  local dir="$1"
  local label="$2"

  if [ -d "$dir" ]; then
    printf "%s%s already installed.%s\n" "$YELLOW" "$label" "$NC"
    printf "%sRemove %s and install fresh? (y/N): %s" "$CYAN" "$dir" "$NC"
    read -r ans
    if [[ ! "$ans" =~ ^[Yy]$ ]]; then
      printf "%sCanceled.%s\n" "$RED" "$NC"
      return 1
    fi
    rm -rf "$dir"
  fi
  return 0
}

ensure_node_and_npm_latest() {
  # Step 1: Node.js (only if missing)
  if command -v node >/dev/null 2>&1; then
    step_skip "Node.js already installed"
  else
    task "Install Node.js (NodeSource LTS)" "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs"
  fi

  # Step 2: npm latest (always try)
  if command -v npm >/dev/null 2>&1; then
    task "Update npm to latest" "sudo npm i -g npm@latest"
  else
    task "Install npm" "sudo apt-get install -y npm"
    task "Update npm to latest" "sudo npm i -g npm@latest"
  fi
}

ensure_pm2() {
  if command -v pm2 >/dev/null 2>&1; then
    step_skip "PM2 already installed"
  else
    task "Install PM2" "sudo npm i -g pm2"
  fi
}

clone_to_dir() {
  local repo="$1"
  local finaldir="$2"

  confirm_reinstall_dir "$finaldir" "$finaldir" || return 1

  local tmpbase
  tmpbase="$(mktemp -d -t airlink.XXXXXX)"
  task "Clone $finaldir repo" "git clone --quiet $repo $tmpbase/src"
  task "Move to $finaldir" "mv $tmpbase/src $finaldir && rm -rf $tmpbase"
}

# ----------- Actions -----------
install_panel() {
  logo
  printf "%sPanel install selected.%s\n\n" "$GREEN" "$NC"

  progress_init 12
  task "APT update" "sudo apt-get update -qq"
  task "Install dependencies" "sudo apt-get install -y curl git gnupg ca-certificates"
  ensure_node_and_npm_latest
  clone_to_dir "https://github.com/JishnuTheGamer/Air-link-panel.git" "panel" || return 0

  task "npm i (panel)" "cd panel && npm i"
  task "Create .env (no overwrite)" "cd panel && cp -n example.env .env"
  task "Prisma migrate" "cd panel && npm run migrate:dev"
  task "Build" "cd panel && npm run build"
  task "Seed" "cd panel && npm run seed"
  ensure_pm2
  task "PM2 start panel" "cd panel && pm2 start dist/app.js --name panel"
  task "PM2 save" "pm2 save"
  printf "\n%sPanel running:%s pm2 logs panel\n" "$GREEN" "$NC"
}

install_daemon() {
  logo
  printf "%sDaemon install selected.%s\n\n" "$GREEN" "$NC"

  progress_init 13
  task "APT update" "sudo apt-get update -qq"
  task "Install dependencies" "sudo apt-get install -y curl git ca-certificates"
  ensure_node_and_npm_latest
  clone_to_dir "https://github.com/AirlinkLabs/daemon.git" "daemon" || return 0

  task "Install TypeScript (global)" "sudo npm i -g typescript --silent"
  task "npm i (daemon)" "cd daemon && npm i --silent"
  task "npm i (daemon/libs)" "cd daemon/libs && npm i --silent"
  task "Create .env (no overwrite)" "cd daemon && [ -f .env ] || cp example.env .env"
  task "Build daemon" "cd daemon && npm run --silent build"

  # Configure (interactive, still logged)
  DONE_STEPS=$((DONE_STEPS + 1))
  _progress_line "Configure daemon (paste command)" ""
  printf "\n%sExample:%s npm run configure -- --panel \"http://localhost:3000\" --key \"**********\"\n" "$BLUE" "$NC"
  while true; do
    printf "%sPaste configure → %s" "$CYAN" "$NC"
    read -r nodecmd
    if [[ $nodecmd =~ ^[[:space:]]*npm[[:space:]]+run[[:space:]]+configure ]] \
       && [[ $nodecmd == *"--panel"* ]] \
       && [[ $nodecmd == *"--key"* ]]; then
      # run it (hidden output) but in log
      bash -c "cd daemon && $nodecmd" >>"$LOG_FILE" 2>&1 || { step_fail "Configure daemon"; return 1; }
      step_ok "Configure daemon"
      break
    else
      printf "%sWrong format. Needs --panel and --key.%s\n" "$RED" "$NC"
    fi
  done

  ensure_pm2
  task "PM2 start daemon" "cd daemon && pm2 start npm --name daemon -- start"
  task "PM2 save" "pm2 save"
  printf "\n%sDaemon running:%s pm2 logs daemon\n" "$GREEN" "$NC"
}

start_all() {
  logo
  printf "%sStarting panel + daemon with PM2...%s\n\n" "$GREEN" "$NC"

  progress_init 3
  ensure_pm2
  task "PM2 restart panel" "pm2 restart panel || pm2 start panel/dist/app.js --name panel"
  task "PM2 restart daemon" "pm2 restart daemon || (cd daemon && pm2 start npm --name daemon -- start)"
  task "PM2 save" "pm2 save"
  printf "\n%sDone.%s\n" "$GREEN" "$NC"
}

install_cloudflared() {
  logo
  printf "%sCloudflared install selected.%s\n\n" "$GREEN" "$NC"

  progress_init 5
  task "APT update" "sudo apt-get update -qq"
  task "Install curl + gnupg" "sudo apt-get install -y curl gnupg ca-certificates"
  task "Add Cloudflare key" "sudo mkdir -p /usr/share/keyrings && curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null"
  task "Add Cloudflared repo" "echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null"
  task "Install cloudflared" "sudo apt-get update -qq && sudo apt-get install -y cloudflared"
  printf "\n%sCloudflared installed.%s\n" "$GREEN" "$NC"
}

install_playit() {
  logo
  printf "%sPlayit tunnel install selected.%s\n\n" "$GREEN" "$NC"

  # Run directly (no task/progress wrapper), so prompts/output work normally.
  bash <(curl -fsSL https://raw.githubusercontent.com/JishnuTheGamer/Vps/refs/heads/main/playit-2)

  pause
}


# ----------- Main Menu -----------
main_menu() {
  need_sudo

  while true; do
    logo
    printf "%s1%s) %sAir-Link Panel Install%s\n" "$GREEN" "$NC" "$YELLOW" "$NC"
    printf "%s2%s) %sAir-Link Node (Daemon) Install%s\n" "$GREEN" "$NC" "$YELLOW" "$NC"
    printf "%s3%s) %sAir-link start Panel + Node%s\n" "$GREEN" "$NC" "$YELLOW" "$NC"
    printf "%s4%s) %sCloudflare install%s\n" "$GREEN" "$NC" "$YELLOW" "$NC"
    printf "%s5%s) %sPlayit tunnel%s\n" "$GREEN" "$NC" "$YELLOW" "$NC"
    printf "%s6%s) %sExit%s\n" "$RED" "$NC" "$RED" "$NC"

    printf "\n%sChoose [1-6]: %s" "$CYAN" "$NC"
    read -r opt

    case "$opt" in
      1) install_panel; pause ;;
      2) install_daemon; pause ;;
      3) start_all; pause ;;
      4) install_cloudflared; pause ;;
      5) install_playit; pause ;;
      6) exit 0 ;;
      *) printf "%sInvalid option.%s\n" "$RED" "$NC"; sleep 1 ;;
    esac
  done
}

main_menu
