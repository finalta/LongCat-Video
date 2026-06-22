#!/bin/bash
set -e
echo "🐱 LongCat-Video-Avatar 1.5 Worker starting..."
echo "   Checkpoint dir : ${CHECKPOINT_DIR}"
echo "   Work dir       : ${WORK_DIR}"

WEIGHTS="${CHECKPOINT_DIR:-/runpod-volume/weights/LongCat-Video-Avatar-1.5}"
if [ ! -d "$WEIGHTS" ]; then
    echo "❌ ERROR: Weights not found at $WEIGHTS"
    exit 1
fi
echo "✅ Weights found at $WEIGHTS"

echo "🔍 Testing Python imports..."
python -c "import runpod; import boto3; print('✅ imports OK')"

echo "🚀 Starting RunPod handler..."
exec python -u /LongCat-Video/handler.py
