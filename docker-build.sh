#!/bin/bash
# Docker setup script for FAF Hackathon

set -e

echo "🐳 Building Docker images for FAF Hackathon..."

# Build all services
docker-compose build

echo "✅ All images built successfully!"
echo ""
echo "To start all services, run:"
echo "  docker-compose up -d"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""
echo "To stop all services:"
echo "  docker-compose down"
