FROM scratch
FROM ubuntu:18.04
LABEL maintainer="vadim@clusterside.com"
ARG VERSION=2.1.0

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install apt-utils \
    && apt-get -y install \
        maven \
        wget \
        git \
        python \
        openjdk-8-jdk-headless \
        patch \
	unzip \
    && cd /tmp \
    && wget http://mirror.linux-ia64.org/apache/atlas/${VERSION}/apache-atlas-${VERSION}-sources.tar.gz \
    && mkdir -p /opt/gremlin \
    && mkdir -p /tmp/atlas-src \
    && tar --strip 1 -xzvf apache-atlas-${VERSION}-sources.tar.gz -C /tmp/atlas-src \
    && rm apache-atlas-${VERSION}-sources.tar.gz \
    && cd /tmp/atlas-src \
    && sed -i 's/http:\/\/repo1.maven.org\/maven2/https:\/\/repo1.maven.org\/maven2/g' pom.xml \
    && export MAVEN_OPTS="-Xms2g -Xmx2g" \
    && export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    && mvn clean -Dmaven.repo.local=/tmp/.mvn-repo -Dhttps.protocols=TLSv1.2 -DskipTests package -Pdist,embedded-hbase-solr \
    && tar -xzvf /tmp/atlas-src/distro/target/apache-atlas-${VERSION}-server.tar.gz -C /opt \
    && rm -Rf /tmp/atlas-src \
    && rm -Rf /tmp/.mvn-repo \
    && apt-get -y --purge remove \
        maven \
        git \
    && apt-get -y remove openjdk-11-jre-headless \
    && apt-get -y autoremove \
    && apt-get -y clean

VOLUME ["/opt/apache-atlas-${VERSION}/conf", "/opt/apache-atlas-${VERSION}/logs"]

COPY atlas_start.py.patch atlas_config.py.patch /opt/apache-atlas-${VERSION}/bin/

RUN cd /opt/apache-atlas-${VERSION}/bin \
    && patch -b -f < atlas_start.py.patch \
    && patch -b -f < atlas_config.py.patch

COPY conf/hbase/hbase-site.xml.template /opt/apache-atlas-${VERSION}/conf/hbase/hbase-site.xml.template
COPY conf/atlas-env.sh /opt/apache-atlas-${VERSION}/conf/atlas-env.sh

COPY conf/gremlin /opt/gremlin/

RUN cd /opt/apache-atlas-${VERSION} \
    && ./bin/atlas_start.py -setup || true

RUN cd /opt/apache-atlas-${VERSION} \
    && ./bin/atlas_start.py & \
    touch /opt/apache-atlas-${VERSION}/logs/application.log \
    && tail -f /opt/apache-atlas-${VERSION}/logs/application.log | sed '/AtlasAuthenticationFilter.init(filterConfig=null)/ q' \
    && sleep 10 \
    && /opt/apache-atlas-${VERSION}/bin/atlas_stop.py

# Start edits from sburn code base to provide an UI in French
# Translate SearchLayoutView_tmpl.html (left search panel on the "legacy" UI)
RUN sed -i -e 's/>Basic</>Simple</' \
        -e 's/>Advanced</>Avancée</' \
        -e 's/title="Refresh"/title="Rafraichir"/' \
        -e 's/>Search By Type</>Recherche par type</' \
        -e 's/title="Entity Attribute Filter"/title="Type d'\''entité à filtrer"/' \
        -e 's/>Search By Classification</>Recherche par tag</' \
        -e 's/title="Tag Attribute Filter"/title="Tag à filtrer"/' \
        -e 's/>Search By Term</>Recherche par mot-clé</' \
        -e 's/>Search By Text</>Recherche en texte intégral</' \
        -e 's/placeholder="Search by text"/placeholder="Search by text"/' \
        -e 's/>Clear</>Effacer</' \
	-e 's/>Search</>Chercher</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/search/SearchLayoutView_tmpl.html   

# Translate SearchLayoutView.js (ie. JS prompts in the left search panel on the "legacy" UI)
RUN sed -i -e 's/>placeholder: "Search Term"</>placeholder: "Mot-clé à rechercher"</' \
        -e 's/title: '\''Advanced Search Queries'\''/title: '\''Requêtes avancées'\''/' \
        -e 's/text('\''Search By Query'\'')/text('\''Recherche par requête'\'')/' \
        -e 's/Search By Query eg./Search By Query ex./' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/views/search/SearchLayoutView.js

RUN sed -i -e 's/>Business Metadata</>Métadonnées métier</' \
        -e 's/>Type System</>Système de types</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/administrator/AdministratorLayoutView_tmpl.html
	
RUN sed -i -e 's/i> Filters</i> Filtres</' \
        -e 's/>Apply</>Appliquer</' \
	-e 's/><span>No Records found!</<span>Aucun résultat trouvé!</' \
        -e 's/title="Collapse">/title="Masquer">/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/audit/AdminAuditTableLayoutView_tmpl.html

RUN sed -i -e 's/title="Previous"/title="Précédent"/' \
        -e 's/title="Next"/title="Suivant"/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/audit/AuditTableLayoutView_tmpl.html
	
RUN sed -i -e 's/<a>Properties </<a>Propriétés </' \
	-e 's/><span>No records found!</<span>Aucun résultat trouvé!</' \
        -e 's/title="Collapse">/title="Masquer">/' \
	-e 's/>Technical properties </>Propriétés techniques </' \
	-e 's/<a>Relationship properties </<a>Propriétés des relations </' \
	-e 's/a>User-defined properties </a>Propriétés définies par les utilisateurs </' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/audit/CreateAuditTableLayoutView_tmpl.html

RUN sed -i -e 's/>Name</>Nom</' \
        -e 's/>Search Weight</>Pondération recherche</' \
	-e 's/>Enable Multivalues</>Valeurs multiples</' \
	-e 's/>Enum Value</>Valeur enum</' \
	-e 's/>Max length</>Longueur max</' \
	-e 's/>Applicable Types</>Types applicables</' \
	-e 's/title="Create\/Update Enum"/title="Créer\/MàJ Enum"/' \
	-e 's/the search weight for the attribute/pondération de recherche associée à l'\''attribut/' \
	-e 's/the entity in the topmost search results when searched for by that attribute/l'\''entité placée en tête pour cette recherche d'\''attribut/' \
	-e 's/Applicable Ranges/Valeurs applicables/' \
	-e 's/Quick search:/Recherche rapide :/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/business_metadata/BusinessMetadataAttributeItemView_tmpl.html

RUN sed -i -e 's/>Cancel</>Annuler</' \
        -e 's/Create Business Metadata Attribute/Créer un attribut associé à une métadonnée métier/' \
	-e 's/i> Attributes/i> Attributs/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/business_metadata/BusinessMetadataAttrTableLayoutView_tmpl.html

RUN sed -i -e 's/>Cancel</>Annuler</' \
        -e 's/Create Business Metadata/Créer une métadonnée métier/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/business_metadata/BusinessMetadataTableLayoutView_tmpl.html

RUN sed -i -e 's/>Name</>Nom</' \
        -e 's/Name(required)/Nom (requis)/' \
	-e 's/Add Business Metadata attribute/Ajouter une métadonnée métier/' \
	-e 's/Add Business Metadata attribute/Ajouter une métadonnée métier/' \
	-e 's/>Cancel</>Annuler</' \
	-e 's/>Attributes</>Attributs</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/business_metadata/CreateBusinessMetadataLayoutView_tmpl.html
	
RUN sed -i -e 's/>Cancel</>Annuler</' \
	-e 's/>Update</>Mettre à jour</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/business_metadata/EnumCreateUpdateItemView_tmpl.html
	
RUN sed -i -e 's/title="Previous"/title="Précédent"/' \
	-e 's/title="Next"/title="Suivant"/' \
	-e 's/title="Goto Page"/title="Aller à la page"/' \
	-e 's/>Page Limit :</>Limite de page :</' \
	-e 's/>Go!</>Aller</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/common/TableLayout_tmpl.html
	
RUN sed -i -e 's/title="Edit Entity"/title="Modif entité"/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/common/buttons_tmpl.html
	
RUN sed -i -e 's/>Classifications:</>Tags :/' \
	-e 's/>Terms:</>Mots-clés :</' \
	-e 's/>Propagated Classifications:</>>Tags propagés:</' \
	-e 's/>Properties</>Propriétés</' \
	-e 's/>Classifications</>Tags</' \
	-e 's/>Export\/Import Audits</>Exporter\/Importer audits</' \
	-e 's/>Schema</>Schéma</' \
	-e 's/>Profile</>Profil</' \
	-e 's/title="Add Classification"/title="Ajouter tag"/' \
	-e 's/title="Add Term"/title="Ajouter mot-clé"/' \
	-e 's/>Profile</>Profil</' \
	-e 's/>Profile</>Profil</' \
	-e 's/>Profile</>Profil</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/detail_page/DetailPageLayoutView_tmpl.html

RUN sed -i -e 's/>Required</>Requis</' \
	-e 's/>All</>Tous</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/entity/CreateEntityLayoutView_tmpl.html

RUN sed -i -e 's/>Business Metadata</>Métadonnées métier</' \
	-e 's/>Add</>Ajouter</' \
	-e 's/>Cancel</>Annuler</' \
	-e 's/>Add New Attribute</>Ajouter un attribut</' \
	-e 's/title="Collapse"/title="Masquer"/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/entity/EntityBusinessMetaDataView_tmpl.html

RUN sed -i -e 's/>Technical properties </>Propriétés techniques</' \
	-e 's/title="Edit Entity"/title="Modif entité"/' \
	-e 's/title="Collapse"/title="Masquer"/' \
	-e 's/title="Show empty values"/title="Afficher valeurs manquantes"/' \
	-e 's/>Edit</>Editer</' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/entity/EntityDetailTableLayoutView_tmpl.html

RUN sed -i -e 's/>Save</>Enregistrer</' \
	-e 's/>Cancel</>Annuler</' \
	-e 's/No labels have been created yet. To add a labels, click/Aucun label n'\''a encore été créé. Pour en ajouter, cliquer/' \
	-e 's/title="Collapse"/title="Masquer"/' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/entity/EntityLabelDefineView_tmpl.html
	
RUN sed -i -e 's/All properties has been removed. To add a property, click /Toutes les propriétés ont été suprimées. Pour en ajouter, cliquer /' \
	-e 's/No properties have been created yet. To add a property, click /Aucune propriété n'\''a été créée. Pour en ajouter, cliquer /' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/entity/EntityUserDefineItemView_tmpl.html

RUN sed -i -e 's/>User-defined properties </>Propriétés définies par les utilisateurs </' \
	-e 's/title="Collapse"/title="Masquer"/' \
	-e 's/>Save</>Enregistrer</' \
	-e 's/>Cancel</>Annuler</' \
	-e 's/No properties have been created yet. To add a property, click /Aucune propriété n'\''a été créée. Pour en ajouter, cliquer /' \
        opt/apache-atlas-${VERSION}/server/webapp/atlas/js/templates/entity/EntityUserDefineView_tmpl.html
