-- ======================================================================
-- ===   Sql Script for Database : Geonet
-- ===
-- === Build : 153
-- ======================================================================

CREATE TABLE Relations
  (
    id         int,
    relatedId  int,

    primary key(id,relatedId)
  );

-- ======================================================================

CREATE TABLE Categories
  (
    id    int,
    name  varchar(32)   not null,

    primary key(id),
    unique(name)
  );

-- ======================================================================

CREATE TABLE Settings
  (
    id        int,
    parentId  int,
    name      varchar(64)    not null,
    value     text,

    primary key(id),

    foreign key(parentId) references Settings(id)
  );

-- ======================================================================

CREATE TABLE Languages
  (
    id    varchar(5),
    name  varchar(32)   not null,
    isocode varchar(3)  not null,
    isInspire char(1)     default 'n',
    isDefault char(1)     default 'n',

    primary key(id)
  );

-- ======================================================================

CREATE TABLE Sources
  (
    uuid     varchar(250),
    name     varchar(250),
    isLocal  char(1)        default 'y',

    primary key(uuid)
  );

-- ======================================================================

CREATE TABLE IsoLanguages
  (
    id    int,
    code  varchar(3)   not null,

    primary key(id),
    unique(code)
  );

-- ======================================================================

CREATE TABLE IsoLanguagesDes
  (
    idDes   int,
    langId  varchar(5),
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references IsoLanguages(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Regions
  (
    id     int,
    north  float   not null,
    south  float   not null,
    west   float   not null,
    east   float   not null,

    primary key(id)
  );

-- ======================================================================

CREATE TABLE RegionsDes
  (
    idDes   int,
    langId  varchar(5),
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Regions(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Users
  (
    id            int,
    username      varchar(32)    not null,
    password      varchar(40)    not null,
    surname       varchar(32),
    name          varchar(32),
    profile       varchar(32)    not null,
    address       varchar(128),
    city          varchar(128),
    state         varchar(32),
    zip           varchar(16),
    country       varchar(128),
    email         varchar(128),
    organisation  varchar(128),
    kind          varchar(16),

    primary key(id),
    unique(username)
  );

-- ======================================================================

CREATE TABLE Operations
  (
    id        int,
    name      varchar(32)   not null,
    reserved  char(1)       default 'n' not null,

    primary key(id)
  );

-- ======================================================================

CREATE TABLE OperationsDes
  (
    idDes   int,
    langId  varchar(5),
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Operations(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Groups
  (
    id           int,
    name         varchar(32)    not null,
    description  varchar(255),
    email        varchar(32),
    referrer     int,

    primary key(id),
    unique(name),

    foreign key(referrer) references Users(id)
  );

-- ======================================================================

CREATE TABLE GroupsDes
  (
    idDes   int,
    langId  varchar(5),
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Groups(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE UserGroups
  (
    userId   int,
    groupId  int,

    primary key(userId,groupId),

    foreign key(userId) references Users(id),
    foreign key(groupId) references Groups(id)
  );

-- ======================================================================

CREATE TABLE CategoriesDes
  (
    idDes   int,
    langId  varchar(5),
    label   varchar(96)   not null,

    primary key(idDes,langId),

    foreign key(idDes) references Categories(id),
    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Metadata
  (
    id           int,
    uuid         varchar(250)   not null,
    schemaId     varchar(32)    not null,
    isTemplate   char(1)        default 'n' not null,
    isHarvested  char(1)        default 'n' not null,
    createDate   varchar(30)    not null,
    changeDate   varchar(30)    not null,
    data         text       not null,
    source       varchar(250)   not null,
    title        varchar(255),
    root         varchar(255),
    harvestUuid  varchar(250)   default null,
    owner        int            not null,
    groupOwner   int            default null,
    harvestUri   varchar(255)   default null,
    rating       int            default 0 not null,
    popularity   int            default 0 not null,
	displayorder int,

    primary key(id),
    unique(uuid),

    foreign key(owner) references Users(id),
    foreign key(groupOwner) references Groups(id)
  );

CREATE INDEX MetadataNDX1 ON Metadata(uuid);
CREATE INDEX MetadataNDX2 ON Metadata(source);

CREATE TABLE Validation
  (
    metadataId   int,
    valType      varchar(40),
    status       int,
    tested       int,
    failed       int,
    valDate      varchar(30),
    
    primary key(metadataId, valType),
    foreign key(metadataId) references Metadata(id)
);
-- ======================================================================

CREATE TABLE MetadataCateg
  (
    metadataId  int,
    categoryId  int,

    primary key(metadataId,categoryId),

    foreign key(metadataId) references Metadata(id),
    foreign key(categoryId) references Categories(id)
  );

-- ======================================================================

CREATE TABLE OperationAllowed
  (
    groupId      int,
    metadataId   int,
    operationId  int,

    primary key(groupId,metadataId,operationId),

    foreign key(groupId) references Groups(id),
    foreign key(metadataId) references Metadata(id),
    foreign key(operationId) references Operations(id)
  );

CREATE INDEX OperationAllowedNDX1 ON OperationAllowed(metadataId);

-- ======================================================================

CREATE TABLE MetadataRating
  (
    metadataId  int,
    ipAddress   varchar(32),
    rating      int           not null,

    primary key(metadataId,ipAddress),

    foreign key(metadataId) references Metadata(id)
  );

-- ======================================================================

CREATE TABLE MetadataNotifiers
  (
    id         int,
    name       varchar(32)    not null,
    url        varchar(255)   not null,
    enabled    char(1)        default 'n' not null,
    username       varchar(32),
    password       varchar(32),

    primary key(id)
  );

-- ======================================================================

CREATE TABLE MetadataNotifications
  (
    metadataId         int,
    notifierId         int,
    notified           char(1)        default 'n' not null,
    metadataUuid       varchar(250)   not null,
    action             char(1)        not null,
    errormsg           text,

    primary key(metadataId,notifierId),

    foreign key(notifierId) references MetadataNotifiers(id)
  );

-- ======================================================================

CREATE TABLE CswServerCapabilitiesInfo
  (
    idField   int,
    langId    varchar(5)    not null,
    field     varchar(32)   not null,
    label     text,

    primary key(idField),

    foreign key(langId) references Languages(id)
  );

-- ======================================================================

CREATE TABLE Requests
  (
    id             int,
    requestDate    varchar(30),
    ip             varchar(128),
    query          varchar(4000),
    hits           int,
    lang           varchar(16),
    sortBy         varchar(128),
    spatialFilter  varchar(4000),
    type           varchar(4000),
    simple         int             default 1,
    autogenerated  int             default 0,
    service        varchar(128),

    primary key(id)
  );

CREATE INDEX RequestsNDX1 ON Requests(requestDate);
CREATE INDEX RequestsNDX2 ON Requests(ip);
CREATE INDEX RequestsNDX3 ON Requests(hits);
CREATE INDEX RequestsNDX4 ON Requests(lang);

-- ======================================================================

CREATE TABLE Params
  (
    id          int,
    requestId   int,
    queryType   varchar(128),
    termField   varchar(128),
    termText    varchar(128),
    similarity  float,
    lowerText   varchar(128),
    upperText   varchar(128),
    inclusive   char(1),

    primary key(id),

    foreign key(requestId) references Requests(id)
  );

CREATE INDEX ParamsNDX1 ON Params(requestId);
CREATE INDEX ParamsNDX2 ON Params(queryType);
CREATE INDEX ParamsNDX3 ON Params(termField);
CREATE INDEX ParamsNDX4 ON Params(termText);

-- ======================================================================

CREATE TABLE HarvestHistory
  (
    id             int not null,
    harvestDate    varchar(30),
		harvesterUuid  varchar(250),
		harvesterName  varchar(128),
		harvesterType  varchar(128),
    deleted        char(1) default 'n' not null,
    info           text,
    params         text,

    primary key(id)

  );

CREATE INDEX HarvestHistoryNDX1 ON HarvestHistory(harvestDate);

-- ======================================================================

CREATE TABLE Thesaurus
  (
    id   varchar(250),
    activated    varchar(1),
    primary key(id)
  );
