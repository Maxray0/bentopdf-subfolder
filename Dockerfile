FROM node:20-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git sed
RUN git clone https://github.com/alam00000/bentopdf.git .

RUN npm ci

# Le piratage chirurgical : On retire UNIQUEMENT l'audit SEO du script officiel.
# On préserve la génération des langues, du sitemap et de la sécurité.
RUN sed -i 's/ && node scripts\/seo-audit.mjs//g' package.json

# Déclaration officielle pour le sous-dossier
ENV BASE_URL=/pdf/
ENV SIMPLE_MODE=true

RUN npm run build

FROM nginxinc/nginx-unprivileged:alpine
COPY --from=builder /app/dist /usr/share/nginx/html/pdf
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
