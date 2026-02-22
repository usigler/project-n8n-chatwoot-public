#!/bin/bash

# Script para deploy usando backend.hcl
# Execute este script a partir do diretório dev/

set -e

BACKEND_CONFIG="../backend.hcl"

echo "🚀 Iniciando deploy da infraestrutura N8N + Chatwoot"
echo "📁 Usando configuração de backend: $BACKEND_CONFIG"

# Função para executar terraform em um módulo
deploy_module() {
    local module_dir=$1
    local module_name=$2
    
    echo ""
    echo "📦 Deployando módulo: $module_name"
    echo "📂 Diretório: $module_dir"
    
    cd "$module_dir"
    
    # Inicializar com backend config
    terraform init -backend-config="$BACKEND_CONFIG"
    
    # Planejar
    terraform plan -var-file="../terraform.auto.tfvars"
    
    # Aplicar (com confirmação)
    read -p "Aplicar as mudanças para $module_name? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        terraform apply -var-file="../terraform.auto.tfvars"
        echo "✅ Módulo $module_name deployado com sucesso!"
    else
        echo "⏭️  Pulando aplicação do módulo $module_name"
    fi
    
    cd ..
}

# Deploy em ordem de dependência
echo ""
echo "📋 Ordem de execução:"
echo "1. VPC"
echo "2. RDS"
echo "3. Redis"
echo "4. EFS"
echo "5. ALB"
echo "6. ECS"
echo "7. WAF"

read -p "Continuar com o deploy? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deploy cancelado"
    exit 1
fi

# Executar módulos em ordem
deploy_module "1-vpc" "VPC"
deploy_module "2-rds" "RDS"
deploy_module "3-redis" "Redis"
deploy_module "4-efs" "EFS"
deploy_module "5-alb" "ALB"
deploy_module "6-ecs" "ECS"
deploy_module "7-waf" "WAF"

echo ""
echo "🎉 Deploy completo!"
echo "📊 Para verificar o status dos recursos, use:"
echo "   terraform show -backend-config=$BACKEND_CONFIG"