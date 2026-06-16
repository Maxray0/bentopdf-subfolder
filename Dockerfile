FROM node:20-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/alam00000/bentopdf.git .
RUN npm ci

# La configuration pour le sous-dossier
ENV BASE_URL=/pdf/
# Le coupe-circuit qui désactive les tests SEO et le marketing
ENV SIMPLE_MODE=true

RUN npm run build

FROM nginxinc/nginx-unprivileged:alpine
COPY --from=builder /app/dist /usr/share/nginx/html/pdf
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
