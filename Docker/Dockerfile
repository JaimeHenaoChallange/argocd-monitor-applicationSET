# filepath: /workspaces/monitor-3/argocd-monitor-applicationSET/Dockerfile
FROM debian:bullseye-slim

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    jq \
    kubectl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar el script al contenedor
COPY retry.sh /usr/local/bin/retry.sh

# Hacer el script ejecutable
RUN chmod +x /usr/local/bin/retry.sh

# Comando por defecto
CMD ["bash", "/usr/local/bin/retry.sh"]