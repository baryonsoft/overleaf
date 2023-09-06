FROM sharelatex/sharelatex:2.7.1


# Patch: Fixes missing dependencies on web startup (https://github.com/overleaf/overleaf/issues/767)
RUN cd /var/www/sharelatex/web && \
    npm install i18next@^19.6.3 i18next-fs-backend@^1.0.7 i18next-http-middleware@^3.0.2
