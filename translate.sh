#!/bin/sh
for i in $(find /opt/apache-atlas-2.1.0/server/webapp/atlas/ -name '*.html'); do
     sed -i -e 's/>About</>A propos</g' \
    -e 's/"Active Entity"/"Entité active"/g' \
    -e 's/>Add attribute values for this classification</>Ajouter des attributs à ce tag</g' \
    -e 's/Add Business Metadata attribute/Ajouter une métadonnée métier/g' \
    -e 's/"Add Category"/"Ajouter catégorie"/g' \
    -e 's/"Add Classification"/"Ajouter tag"/g' \
    -e 's/>Add New Attribute</>Ajouter un attribut</g' \
    -e 's/> Add New Attributes</> Ajouter de nouveaux attributs</g' \
    -e 's/"Add Term"/"Ajouter mot-clé"/g' \
    -e 's/> Add Validity Period</> Ajouter une période de validité</g' \
    -e 's/>Advanced</>Avancée</g' \
    -e 's/'\''Advanced Search Queries'\''/title: '\''Requêtes avancées'\''/g' \
    -e 's/>All</>Tous</g' \
    -e 's/All properties has been removed. To add a property, click /Toutes les propriétés ont été suprimées. Pour en ajouter, cliquer /g' \
    -e 's/>API Documentation</>Documentation de l'\''API</g' \
    -e 's/Applicable Ranges/Valeurs applicables/g' \
    -e 's/>Applicable Types</>Types applicables</g' \
    -e 's/>Apply</>Appliquer</g' \
    -e 's/> Apply Validity Period</>Appliquerune période de validité</g' \
    -e 's/"Assign Classification"/"Assigner un tag"/g' \
    -e 's/>Attributes</>Attributs</g' \
    -e 's/>Attributes:</>Attributs :</g' \
    -e 's/> Attributes</> Attributs</g' \
    -e 's/>Attributes(optional)</> Attributs (facultatif)</g' \
    -e 's/>Attributes define additional properties for the classification</>Les attributs définissent des propriétés additionnelles associées aux tags</g' \
    -e 's/>Average Length</>Longueur moyenne</g' \
    -e 's/>Avg Time </>Temps moyen</g' \
    -e 's/> Back To Results</> Retour aux résultats</g' \
    -e 's/> Back To Year</> Retour à l'\''année</g' \
    -e 's/>Basic</>Simple</g' \
    -e 's/>Bulk Import</>Import en masse</g' \
    -e 's/>Business Metadata</>Métadonnées métier</g' \
    -e 's/>Browse</>Naviguer</g' \
    -e 's/>Cancel</>Annuler</g' \
    -e 's/>Cardinality</>Cardinalité</g' \
    -e 's/>Categories:</>Catégories :</g' \
    -e 's/>Category</>Categorie</g' \
    -e 's/> Classification</> Tag</g' \
    -e 's/>Classification Attributes(optional)</> Attributs du tag (facultatif)</g' \
    -e 's/>Classifications</>Tags</g' \
    -e 's/>Classifications:</>Tags :/g' \
    -e 's/>Clear</>Effacer</g' \
    -e 's/"Collapse"/"Masquer"/g' \
    -e 's/>Count</>Décompte</g' \
    -e 's/okLabel = '\''Create'\''/okLabel = '\''Créer'\''/g' \
    -e 's/Create Business Metadata/Créer une métadonnée métier/g' \
    -e 's/Create Business Metadata Attribute/Créer un attribut associé à une métadonnée métier/g' \
    -e 's/entityTitle = '\''Create entity'\''/entityTitle = '\''Créer une entité'\''/g' \
    -e 's/>&nbsp;Create Entity</>&nbsp;Créer une entité</g' \
    -e 's/> create new entity </> créer une entité </g' \
    -e 's/"Create\/Update Enum"/"Créer\/MàJ Enum"/g' \
    -e 's/>Creates</>Créations</g' \
    -e 's/>Custom Filters</>Filtres</g' \
    -e 's/>Date Created</>Date de création</g' \
    -e 's/>DB</>BDD</g' \
    -e 's/>Deleted</>Supprimée</g' \
    -e 's/>Deletes</>Suppressions</g' \
    -e 's/"Deleted Entity"/"Entité supprimée"/g' \
    -e 's/>Depth:</>Profondeur :</g' \
    -e 's/>Direct super-classifications:</>Propager les tags vers les entités précédentes :</g' \
    -e 's/>Direct sub-classifications:</>Propager les tags vers les entités suivantes :</g' \
    -e 's/>Download Import template</>Télécharger un modèle pour import</g' \
    -e 's/>Edit</>Modifier</g' \
    -e 's/"Edit Entity"/"Modifier entité"/g' \
    -e 's/>Enable\/Disable Propagation</>Activer\/Désactiver la propagation</g' \
    -e 's/>Enable Multivalues</>Valeurs multiples</g' \
    -e 's/>End Time</>Fin</g' \
    -e 's/>Enum Value</>Valeur enum</g' \
    -e 's/>Entities</>Entités</g' \
    -e 's/"Entities, Classifications , Glossaries"/"Entités, tags, mots-clés"/g' \
    -e 's/"Entity Attribute Filter"/"Type d'\''entité à filtrer"/g' \
    -e 's/>Entity-types:</>Types d'\''entités :</g' \
    -e 's/>Exclude sub-classifications</>Exclure les sous-classifications</g' \
    -e 's/>Exclude sub-types</>Exclure les sous-types</g' \
    -e 's/>Export\/Import Audits</>Exporter\/Importer audits</g' \
    -e 's/"Export to PNG"/"Exporter en PNG"/g' \
    -e 's/>Failed</>Echecs</g' \
    -e 's/>Favorite Searches</>Recherches favorites</g' \
    -e 's/"Filter"/"Filtrer"/g' \
    -e 's/> Filters</> Filtres</g' \
    -e 's/>Filters</>Filtres</g' \
    -e 's/"Full screen"/"Plein écran"/g' \
    -e 's/>Get involved!</>Participez !</g' \
    -e 's/>Glossary</>Glossaire</g' \
    -e 's/> Glossary</> Glossaire</g' \
    -e 's/>Glossaries</>Mots-clés</g' \
    -e 's/>Go!</>Aller</g' \
    -e 's/"Goto Page"/"Aller à la page"/g' \
    -e 's/>Graph</>Graphe</g' \
    -e 's/>Help</>Aide</g' \
    -e 's/>Hide Process</>Masquer processus</g' \
    -e 's/>Hide Deleted Entity</>Masquer entité supprimée</g' \
    -e 's/>Import Glossary</>Importer glossaire</g' \
    -e 's/>Key</>Clé</g' \
    -e 's/>Logout</>Se déconnecter</g' \
    -e 's/>Long Description</>Description longue</g' \
    -e 's/"Long Description"/"Description longue"/g' \
    -e 's/Long Description:/Description longue :/g' \
    -e 's/>Max length</>Longueur max</g' \
    -e 's/>Max Length</>Longueur max</g' \
    -e 's/>Mean</>Moyenne</g' \
    -e 's/>Median</>Médiane</g' \
    -e 's/>Memory</>Mémoire</g' \
    -e 's/>Migration is </>La migration est </g' \
    -e 's/More sample queries and use-cases/Plus d'\''exemples de requêtes et de cas d'\''usage/g' \
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
    -e 's/>Period</>Période</g' \
    -e 's/>Please select one\/more column to see the data</>Sélectionner au moins une colonne pour voir les données</g' \
    -e 's/"Previous"/"Précédent"/g' \
    -e 's/>Profile</>Profil</g' \
    -e 's/> Propagate</>Propager</g' \
    -e 's/>Propagated Classifications:</>Tags propagés:</g' \
    -e 's/"Propagated classification are removed during entity delete"/"Les tags propagés sont effacés en supprimant l'\''entité"/g' \
    -e 's/>Properties</>Propriétés</g' \
    -e 's/>Properties </>Propriétés </g' \
    -e 's/> property and restart Atlas.</> et redémarrer Atlas.</g' \
    -e 's/Quick search:/Recherche rapide :/g' \
    -e 's/"Realign Lineage"/"Réaligner le lignage"/g' \
    -e 's/"Refresh"/"Rafraichir"/g' \
    -e 's/"Refresh Data"/"Rafraichir les données"/g' \
    -e 's/>Related Terms</>Mots-clés associés</g' \
    -e 's/>Relationship properties </>Propriétés des relations </g' \
    -e 's/> Remove propagation on entity delete</> Effacer la propagation en supprimant l'\''entité</g' \
    -e 's/>Required</>Requis</g' \
    -e 's/>Rows</>Lignes</g' \
    -e 's/>Runtime</>Exécution</g' \
    -e 's/>Save</>Enregistrer</g' \
    -e 's/>Save As</>Enregistrer sous</g' \
    -e 's/>Schema</>Schéma</g' \
    -e 's/"Search"/"Chercher"/g' \
    -e 's/> Search</> Recherche</g' \
    -e 's/>Search Atlas for existing entities/>Chercher les entités existantes/g' \
    -e 's/>Search By Classification</>Recherche par tag</g' \
    -e 's/'\''Search By Query'\''/'\''Recherche par requête'\''/g' \
    -e 's/Search By Query eg./Search By Query ex./g' \
    -e 's/>Search By Term</>Recherche par mot-clé</g' \
    -e 's/}Search Catalog{/}Chercher dans le catalogue{/g' \
    -e 's/>Select Classifications to Block Propagation</>Sélectionner les tags pour bloquer la propagation</g' \
    -e 's/"Search Classification"/"Chercher tag"/g' \
    -e 's/"Search Entities"/"Chercher des entités"/g' \
    -e 's/"Search entities"/"Chercher des entités"/g' \
    -e 's/Search Glossary, Category/Chercher dans catalogue, catégorie/g' \
    -e 's/Search Glossary, Term/Chercher dans glossaire, mot-clé/g' \
    -e 's/>"Search Term"</>"Chercher mot-clé"</g' \
    -e 's/}Search Term{/}Chercher mot-clé{/g' \
    -e 's/>Search By Text</>Recherche en texte intégral</g' \
    -e 's/"Search by text"/"Recherche en texte intégral"/g' \
    -e 's/>Search By Type</>Recherche par type</g' \
    -e 's/>"Search for active entities of type/"Chercher des entités active de type/g' \
    -e 's/>"Search for deleted entities of type/"Chercher des entités supprimées de type/g' \
    -e 's/>"Search for shell entities of type/"Chercher des entités partielles de type/g' \
    -e 's/>Search Lineage Entity</>Chercher une entité de lignage</g' \
    -e 's/>Search Weight</>Pondération recherche</g' \
    -e 's/>Select Classifications to Block Propagation</>Choisir des tags pour bloquer la propagation</g' \
    -e 's/>Select classification to inherit attributes(optional)</>Choisir un tag pour hériter des attributs (facultatif)</g' \
    -e 's/>Select Term</>Choisir mot-clé</g' \
    -e 's/>Settings</>Options</g' \
    -e 's/"Settings"/"Options"/g' \
    -e 's/>Short Description</>Description courte</g' \
    -e 's/"Short Description"/"Description courte"/g' \
    -e 's/Short Description:/Description courte :/g' \
    -e 's/"Show empty values"/"Afficher valeurs manquantes"/g' \
    -e 's/>Show Empty Values</>Afficher les valeurs manquantes</g' \
    -e 's/>Show historical entities</>Afficher les entités historiques</g' \
    -e 's/> Show Propagated Classifications</> Afficher les tags propagés</g' \
    -e 's/>Show node details on hover</>Afficher les détails de l'\''entité au survol de la souris</g' \
    -e 's/>Single Query</>Requête unique</g' \
    -e 's/>Start Time</>Début</g' \
    -e 's/"Statistics"/"Statistique"/g' \
    -e 's/>successful</>réussie</g' \
    -e 's/>Switch to New</>Nouvelle interface</g' \
    -e 's/Switch to Classic</Interface classique</g' \
    -e 's/>System Details</>Détails système</g' \
    -e 's/>Table</>Tableau</g' \
    -e 's/"Tag Attribute Filter"/"Tag à filtrer"/g' \
    -e 's/>TimeZone</>Fuseau horaire</g' \
    -e 's/>Technical properties </>Propriétés techniques </g' \
    -e 's/>Terms:</>Mots-clés :</g' \
    -e 's/the entity in the topmost search results when searched for by that attribute/l'\''entité placée en tête pour cette recherche d'\''attribut/g' \
    -e 's/the search weight for the attribute/pondération de recherche associée à l'\''attribut/g' \
    -e 's/To exit form migration mode, please remove </Pour sortir du mode migration, supprimer le fichier de propriétés /g' \
    -e 's/>Type System</>Système de types</g' \
    -e 's/>Update</>Mettre à jour</g' \
    -e 's/>Updates</>Met à jour</g' \
    -e 's/>Use DSL (Domain Specific Language) to build queries</>Utiliser le DSL (Domain Specific Language) pour construire des requêtes</g' \
    -e 's/>User-defined properties </>Propriétés définies par les utilisateurs </g' \
    -e 's/>Value</>Valeur</g' \
    -e 's/>You don'\''t have any favorite search.</>Vous n'\''avez pas de recherche favorite.</g' \
    -e 's/"Zoom In"/"Zoomer"/g' \
    -e 's/"Zoom Out"/"Dézoomer"/g' \
    $i
done
