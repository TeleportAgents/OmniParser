#!/bin/bash

# Define the model directory
MODEL_DIR="./weights"

# Function to download model checkpoints
download() {
  echo "Downloading model checkpoints to $MODEL_DIR..."
  mkdir -p "$MODEL_DIR"

  for f in icon_detect/{train_args.yaml,model.pt,model.yaml} \
    icon_caption/{config.json,generation_config.json,model.safetensors}; do
    conda run --no-capture-output -n omni huggingface-cli download microsoft/OmniParser-v2.0 "$f" --local-dir "$MODEL_DIR"
  done

  mv "$MODEL_DIR/icon_caption" "$MODEL_DIR/icon_caption_florence"
  echo "Download complete."
}

# Function to run the Python script
run() {
  echo "Running script with conda environment..."
  cd ./omnitool/omniparserserver/
  conda run --no-capture-output -n omni python omniparserserver.py
}

# Parse the command-line argument
case "$1" in
dl)
  download
  ;;
run)
  run
  ;;
*)
  echo "Usage: $0 {dl|run}"
  exit 1
  ;;
esac
