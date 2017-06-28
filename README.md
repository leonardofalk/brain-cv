# BrainCV

BrainCV é uma aplicação em Rails que utiliza redes neurais para verificar, dada uma imagem de tomografia axial, se uma pessoa tem ou não esclerose.

# Dependências

- OpenCV
- Ruby
- Rails

# Instalação

A aplicação foi colocada em um container do docker (https://docs.docker.com/engine/installation/), então basta executar o comando:

```bash
docker run -d brain-cv -p 3000:3000
```

A aplicação estará rodando em `localhost:3000`.
