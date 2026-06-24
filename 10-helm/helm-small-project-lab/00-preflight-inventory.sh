#!/usr/bin/env bash

LAB_ROOT="$(pwd)"
REPO_URL="https://github.com/LironeFitoussi/helm-small-project.git"
INVENTORY="$LAB_ROOT/00-inventory"
SOURCE="$LAB_ROOT/01-source"
REPO_DIR="$SOURCE/helm-small-project"

mkdir -p "$INVENTORY/docker"
mkdir -p "$INVENTORY/kubernetes"
mkdir -p "$INVENTORY/helm"
mkdir -p "$INVENTORY/filesystem/trees"
mkdir -p "$INVENTORY/repo"
mkdir -p "$SOURCE"
mkdir -p "$LAB_ROOT/02-work"
mkdir -p "$LAB_ROOT/03-notes"
mkdir -p "$LAB_ROOT/04-exports"

NOW="$(date '+%Y-%m-%d %H:%M:%S')"

run_cmd() {
  TITLE="$1"
  OUTFILE="$2"

  {
    echo ""
    echo "============================================================"
    echo "$TITLE"
    echo "============================================================"
    echo ""
    eval "$TITLE" 2>&1
  } >> "$OUTFILE"
}

echo "Preflight Inventory - helm-small-project-lab" > "$INVENTORY/SUMMARY.txt"
echo "Generated: $NOW" >> "$INVENTORY/SUMMARY.txt"
echo "" >> "$INVENTORY/SUMMARY.txt"
echo "Lab root: $LAB_ROOT" >> "$INVENTORY/SUMMARY.txt"
echo "Repo: $REPO_URL" >> "$INVENTORY/SUMMARY.txt"
echo "" >> "$INVENTORY/SUMMARY.txt"

TOOLS="$INVENTORY/tools-versions.txt"
echo "Generated: $NOW" > "$TOOLS"

run_cmd "git --version" "$TOOLS"
run_cmd "docker version" "$TOOLS"
run_cmd "docker compose version" "$TOOLS"
run_cmd "kubectl version --client" "$TOOLS"
run_cmd "helm version" "$TOOLS"
run_cmd "python --version" "$TOOLS"
run_cmd "code --version" "$TOOLS"

REPO_LOG="$INVENTORY/repo/repo-clone-update.txt"
echo "Generated: $NOW" > "$REPO_LOG"

if [ ! -d "$REPO_DIR/.git" ]; then
  run_cmd "git clone $REPO_URL \"$REPO_DIR\"" "$REPO_LOG"
else
  cd "$REPO_DIR" || exit 1
  run_cmd "git status" "$REPO_LOG"
  run_cmd "git pull" "$REPO_LOG"
  cd "$LAB_ROOT" || exit 1
fi

if [ -d "$REPO_DIR" ]; then
  cd "$REPO_DIR" || exit 1
  find . -print > "$INVENTORY/repo/repo-tree.txt"
  git status > "$INVENTORY/repo/repo-git-status.txt" 2>&1
  git log --oneline -n 20 >> "$INVENTORY/repo/repo-git-status.txt" 2>&1
  find . -type f | sort > "$INVENTORY/repo/repo-files.txt"
  cd "$LAB_ROOT" || exit 1
fi

run_cmd "docker version" "$INVENTORY/docker/docker-version.txt"
run_cmd "docker info" "$INVENTORY/docker/docker-info.txt"
run_cmd "docker ps -a" "$INVENTORY/docker/containers.txt"
run_cmd "docker images" "$INVENTORY/docker/images.txt"
run_cmd "docker volume ls" "$INVENTORY/docker/volumes.txt"
run_cmd "docker network ls" "$INVENTORY/docker/networks.txt"
run_cmd "docker context ls" "$INVENTORY/docker/contexts.txt"

run_cmd "kubectl config get-contexts" "$INVENTORY/kubernetes/contexts.txt"
run_cmd "kubectl config current-context" "$INVENTORY/kubernetes/current-context.txt"
run_cmd "kubectl cluster-info" "$INVENTORY/kubernetes/cluster-info.txt"
run_cmd "kubectl get nodes -o wide" "$INVENTORY/kubernetes/nodes.txt"
run_cmd "kubectl get ns" "$INVENTORY/kubernetes/namespaces.txt"
run_cmd "kubectl get all -A" "$INVENTORY/kubernetes/all-resources-all-namespaces.txt"
run_cmd "kubectl get pvc -A" "$INVENTORY/kubernetes/pvc-all-namespaces.txt"
run_cmd "kubectl get storageclass" "$INVENTORY/kubernetes/storageclasses.txt"

run_cmd "helm version" "$INVENTORY/helm/helm-version.txt"
run_cmd "helm repo list" "$INVENTORY/helm/helm-repos.txt"
run_cmd "helm list -A" "$INVENTORY/helm/helm-releases-all-namespaces.txt"

PATHS_TO_SCAN=(
  "/e/Genspark/devops-field-guide/10-helm"
  "/e/Genspark/devops-field-guide"
  "/e/Genspark/DevOps-Materials"
  "/e/Genspark/microservices-docker"
  "/c/Users/David/Desktop/Labs"
  "/c/Users/David/Desktop/Kubeinertis"
  "/c/Users/David/Desktop/softlink_lab"
  "/c/Users/David/Desktop/python-module"
)

MARKERS_REGEX='Dockerfile|docker-compose.yml|docker-compose.yaml|compose.yml|compose.yaml|Chart.yaml|values.yaml|requirements.txt|pyproject.toml|package.json|deployment.yaml|service.yaml|ingress.yaml|configmap.yaml|secret.yaml|statefulset.yaml|README.md'

PATHS_STATUS="$INVENTORY/filesystem/paths-existence.txt"
ALL_FILES="$INVENTORY/filesystem/all-scanned-files.txt"
PROJECT_MARKERS="$INVENTORY/filesystem/project-markers.txt"

echo "Generated: $NOW" > "$PATHS_STATUS"
echo "Generated: $NOW" > "$ALL_FILES"
echo "Generated: $NOW" > "$PROJECT_MARKERS"

for P in "${PATHS_TO_SCAN[@]}"; do
  echo "" >> "$PATHS_STATUS"
  echo "PATH: $P" >> "$PATHS_STATUS"

  if [ -d "$P" ]; then
    echo "STATUS: EXISTS" >> "$PATHS_STATUS"

    SAFE_NAME="$(echo "$P" | sed 's#[/:\\ ]#_#g')"
    find "$P" \
      -path "*/.git" -prune -o \
      -path "*/node_modules" -prune -o \
      -path "*/.venv" -prune -o \
      -path "*/venv" -prune -o \
      -path "*/__pycache__" -prune -o \
      -print > "$INVENTORY/filesystem/trees/$SAFE_NAME.txt" 2>/dev/null

    find "$P" \
      -path "*/.git" -prune -o \
      -path "*/node_modules" -prune -o \
      -path "*/.venv" -prune -o \
      -path "*/venv" -prune -o \
      -path "*/__pycache__" -prune -o \
      -type f -print >> "$ALL_FILES" 2>/dev/null

    find "$P" \
      -path "*/.git" -prune -o \
      -path "*/node_modules" -prune -o \
      -path "*/.venv" -prune -o \
      -path "*/venv" -prune -o \
      -path "*/__pycache__" -prune -o \
      -type f -regextype posix-extended -regex ".*\/($MARKERS_REGEX)$" -print >> "$PROJECT_MARKERS" 2>/dev/null
  else
    echo "STATUS: MISSING" >> "$PATHS_STATUS"
  fi
done

DOCKER_CONTAINERS="$(docker ps -a -q 2>/dev/null | wc -l | tr -d ' ')"
DOCKER_IMAGES="$(docker images -q 2>/dev/null | sort -u | wc -l | tr -d ' ')"
MARKER_COUNT="$(grep -v '^Generated:' "$PROJECT_MARKERS" | grep -v '^$' | wc -l | tr -d ' ')"

{
  echo ""
  echo "Results folder:"
  echo "$INVENTORY"
  echo ""
  echo "Counts:"
  echo "Docker containers: $DOCKER_CONTAINERS"
  echo "Docker images: $DOCKER_IMAGES"
  echo "Project marker files: $MARKER_COUNT"
  echo ""
  echo "Important files:"
  echo "00-inventory/SUMMARY.txt"
  echo "00-inventory/tools-versions.txt"
  echo "00-inventory/docker/containers.txt"
  echo "00-inventory/docker/images.txt"
  echo "00-inventory/kubernetes/current-context.txt"
  echo "00-inventory/kubernetes/nodes.txt"
  echo "00-inventory/helm/helm-releases-all-namespaces.txt"
  echo "00-inventory/filesystem/project-markers.txt"
  echo "00-inventory/repo/repo-tree.txt"
} >> "$INVENTORY/SUMMARY.txt"

cat > "$LAB_ROOT/helm-small-project-lab.code-workspace" <<'WORKSPACE'
{
  "folders": [
    {
      "name": "LAB_ROOT",
      "path": "."
    },
    {
      "name": "SOURCE_REPO",
      "path": "01-source/helm-small-project"
    },
    {
      "name": "INVENTORY",
      "path": "00-inventory"
    }
  ],
  "settings": {
    "terminal.integrated.defaultProfile.windows": "Git Bash",
    "files.exclude": {
      "**/.git": true,
      "**/__pycache__": true,
      "**/.venv": true,
      "**/venv": true,
      "**/node_modules": true
    }
  }
}
WORKSPACE

echo ""
echo "DONE"
echo "Inventory created at:"
echo "$INVENTORY"
echo ""
