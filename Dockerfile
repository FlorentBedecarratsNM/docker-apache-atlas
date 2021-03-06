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
RUN for i in $(ls templates/*/*.html); do \
    sed -i -e 's/"Active Entity"/"Entité active"/g' \
        -e 's/Add Business Metadata attribute/Ajouter une métadonnée métier/g' \
	-e 's/"Add Category"/"Ajouter catégorie"/g' \
	-e 's/"Add Classification"/"Ajouter tag"/g' \
	-e 's/>Add New Attribute</>Ajouter un attribut</g' \
	-e 's/"Add Term"/"Ajouter mot-clé"/g' \
	-e 's/>Advanced</>Avancée</g' \
	-e 's/'\''Advanced Search Queries'\''/title: '\''Requêtes avancées'\''/g' \
	-e 's/>All</>Tous</g' \
	-e 's/All properties has been removed. To add a property, click /Toutes les propriétés ont été suprimées. Pour en ajouter, cliquer /g' \
	-e 's/Applicable Ranges/Valeurs applicables/g' \
	-e 's/>Applicable Types</>Types applicables</g' \
	-e 's/>Apply</>Appliquer</g' \
	-e 's/"Assign Classification"/"Assigner un tag"/g' \
	-e 's/>Attributes</>Attributs</g' \
	-e 's/> Attributes</> Attributs</g' \
	-e 's/>Average Length</>Longueur moyenne</g' \
	-e 's/> Back To Year</> Retour à l'\''année</g' \
	-e 's/>Basic</>Simple</g' \
	-e 's/>Business Metadata</>Métadonnées métier</g' \
	-e 's/>Cancel</>Annuler</g' \
	-e 's/>Cardinality</>Cardinalité</g' \
	-e 's/>Categories:</>Catégories :</g' \
	-e 's/>Category</>Categorie</g' \
	-e 's/>Classifications</>Tags</g' \
	-e 's/>Classifications:</>Tags :/g' \
	-e 's/>Clear</>Effacer</g' \
	-e 's/"Collapse"/"Masquer"/g' \
	-e 's/Create Business Metadata/Créer une métadonnée métier/g' \
	-e 's/Create Business Metadata Attribute/Créer un attribut associé à une métadonnée métier/g' \
	-e 's/"Create\/Update Enum"/"Créer\/MàJ Enum"/g' \
	-e 's/>Date Created</>Date de création</g' \
	-e 's/>DB</>BDD</g' \
	-e 's/>Deleted</>Supprimée</g' \
	-e 's/"Deleted Entity"/"Entité supprimée"/g' \
	-e 's/>Depth:</>Profondeur :</g' \
	-e 's/>Download Import template</>Télécharger un modèle pour import</g' \
	-e 's/>Edit</>Modifier</g' \
	-e 's/"Edit Entity"/"Modifier entité"/g' \
	-e 's/>Enable\/Disable Propagation</>Activer\/Désactiver la propagation</g' \
	-e 's/>Enable Multivalues</>Valeurs multiples</g' \
	-e 's/>Enum Value</>Valeur enum</g' \
	-e 's/>Entities</>Entités</g' \
	-e 's/"Entity Attribute Filter"/"Type d'\''entité à filtrer"/g' \
	-e 's/>Export\/Import Audits</>Exporter\/Importer audits</g' \
	-e 's/"Export to PNG"/"Exporter en PNG"/g' \
	-e 's/"Filter"/"Filtrer"/g' \
	-e 's/> Filters</> Filtres</g' \
	-e 's/>Filters</>Filtres</g' \
	-e 's/"Full screen"/"Plein écran"/g' \
	-e 's/>Go!</>Aller</g' \
	-e 's/"Goto Page"/"Aller à la page"/g' \
	-e 's/>Graph</>Graphe</g' \
	-e 's/>Hide Process</>Masquer processus</g' \
	-e 's/>Hide Deleted Entity</>Masquer entité supprimée</g' \
	-e 's/>Import Glossary</>Importer glossaire</g' \
	-e 's/>Key</>Clé</g' \
	-e 's/>Long Description</>Description longue</g' \
	-e 's/"Long Description"/"Description longue"/g' \
	-e 's/Long Description:/Description longue :/g' \
	-e 's/>Max length</>Longueur max</g' \
	-e 's/>Max Length</>Longueur max</g' \
	-e 's/>Mean</>Moyenne</g' \
	-e 's/>Median</>Médiane</g' \
	-e 's/>Name</>Nom</g' \
	-e 's/Name(required)/Nom (requis)/g' \
	-e 's/"Next"/"Suivant"/g' \
	-e 's/No labels have been created yet. To add a labels, click/Aucun label n'\''a encore été créé. Pour en ajouter, cliquer/g' \
	-e 's/>No Profile to Show!</>Aucun profil à afficher !</g' \
	-e 's/No properties have been created yet. To add a property, click /Aucune propriété n'\''a été créée. Pour en ajouter, cliquer /g' \
	-e 's/>No Records found!</>Aucun résultat trouvé!</g' \
	-e 's/>No records found!</>Aucun résultat trouvé!</g' \
	-e 's/>No Tables to Show!</>Aucune table à afficher !</g' \
	-e 's/>None</>Aucun</g' \
	-e 's/>On hover show current path</>Filtrer l'\''affichage au survol de la souris</g' \
	-e 's/>Page Limit :</>Limite de page :</g' \
	-e 's/"Previous"/"Précédent"/g' \
	-e 's/>Profile</>Profil</g' \
	-e 's/>Propagated Classifications:</>>Tags propagés:</g' \
	-e 's/>Properties</>Propriétés</g' \
	-e 's/>Properties </>Propriétés </g' \
	-e 's/Quick search:/Recherche rapide :/g' \
	-e 's/"Realign Lineage"/"Réaligner le lignage"/g' \
	-e 's/"Refresh"/"Rafraichir"/g' \
	-e 's/>Related Terms</>Mots-clés associés</g' \
	-e 's/>Relationship properties </>Propriétés des relations </g' \
	-e 's/>Required</>Requis</g' \
	-e 's/>Rows</>Lignes</g' \
	-e 's/>Save</>Enregistrer</g' \
	-e 's/>Schema</>Schéma</g' \
	-e 's/"Search"/"Chercher"/g' \
	-e 's/>Search By Classification</>Recherche par tag</g' \
	-e 's/'\''Search By Query'\''/'\''Recherche par requête'\''/g' \
	-e 's/Search By Query eg./Search By Query ex./g' \
	-e 's/>Search By Term</>Recherche par mot-clé</g' \
	-e 's/}Search Catalog{/}Chercher dans le catalogue{/g' \
	-e 's/>Select Classifications to Block Propagation</>Select Classifications to Block Propagation</g' \
	-e 's/"Search Entities"/"Chercher des entités"/g' \
	-e 's/Search Glossary, Category/Chercher dans catalogue, catégorie/g' \
	-e 's/Search Glossary, Term/Chercher dans glossaire, mot-clé/g' \
	-e 's/>"Search Term"</>"Chercher mot-clé"</g' \
	-e 's/}Search Term{/}Chercher mot-clé{/g' \
	-e 's/>Search By Text</>Recherche en texte intégral</g' \
	-e 's/"Search by text"/"Recherche en texte intégral"/g' \
	-e 's/>Search By Type</>Recherche par type</g' \
	-e 's/>Search Lineage Entity</>Chercher une entité de lignage</g' \
	-e 's/>Search Weight</>Pondération recherche</g' \
	-e 's/>Select Classifications to Block Propagation</>Choisir des tags pour bloquer la propagation</g' \
	-e 's/>Select Term</>Choisir mot-clé</g' \
	-e 's/>Settings</>Options</g' \
	-e 's/"Settings"/"Options"/g' \
	-e 's/>Short Description</>Description courte</g' \
	-e 's/"Short Description"/"Description courte"/g' \
	-e 's/Short Description:/Description courte :/g' \
	-e 's/"Show empty values"/"Afficher valeurs manquantes"/g' \
	-e 's/>Show Empty Values</>Afficher les valeurs manquantes</g' \
	-e 's/>Show historical entities</>Afficher les entités historiques</g' \
	-e 's/>Show node details on hover</>Afficher les détails de l'\''entité au survol de la souris</g' \
	-e 's/>Table</>Tableau</g' \
	-e 's/"Tag Attribute Filter"/"Tag à filtrer"/g' \
	-e 's/>Technical properties </>Propriétés techniques </g' \
	-e 's/>Terms:</>Mots-clés :</g' \
	-e 's/the entity in the topmost search results when searched for by that attribute/l'\''entité placée en tête pour cette recherche d'\''attribut/g' \
	-e 's/the search weight for the attribute/pondération de recherche associée à l'\''attribut/g' \
	-e 's/>Type System</>Système de types</g' \
	-e 's/>Update</>Mettre à jour</g' \
	-e 's/>User-defined properties </>Propriétés définies par les utilisateurs </g' \
	-e 's/>Value</>Valeur</g' \
	-e 's/"Zoom In"/"Zoomer"/g' \
	-e 's/"Zoom Out"/"Dézoomer"/g' \
	$i \
done
