cat > tekton/README.md <<'MD'
# Tekton (local Kubernetes) notes

## One-time setup
1. Ensure Docker Desktop Kubernetes is enabled.
2. Install Tekton Pipelines into the cluster (tekton-pipelines namespace).
3. Create the workspace PVC used by PipelineRuns (bill-tracker-workspace-pvc).
4. Deploy Postgres used by in-cluster tests:
   - kubectl apply -f tekton/resources/postgres.yaml

## Run backend tests in Tekton (branch-aware)
From the repo root:

- ./tekton/run-backend-tests.sh

This script:
- Uses your current git branch as the Tekton clone revision
- Runs backend tests with:
   - spring profile: test
   - Testcontainers tests excluded via JUnit tag filtering

## Testcontainers strategy (Pattern A)
- Testcontainers tests are tagged: @Tag("testcontainers")
- Tekton excludes them using:
   - ./gradlew test -PexcludeTags=testcontainers
- Local + GitHub Actions can run them as needed.
  MD
