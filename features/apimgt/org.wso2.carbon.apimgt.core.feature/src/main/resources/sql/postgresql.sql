﻿BEGIN TRANSACTION;

-- Start of IDN Tables --
DROP TABLE IF EXISTS IDN_BASE_TABLE;
CREATE TABLE IDN_BASE_TABLE (
            PRODUCT_NAME VARCHAR(20),
            PRIMARY KEY (PRODUCT_NAME)
);

INSERT INTO IDN_BASE_TABLE values ('WSO2 Identity Server');

DROP TABLE IF EXISTS IDN_OAUTH_CONSUMER_APPS;
CREATE TABLE IDN_OAUTH_CONSUMER_APPS (
            CONSUMER_KEY VARCHAR(255),
            CONSUMER_SECRET VARCHAR(512),
            USERNAME VARCHAR(255),
            TENANT_ID INTEGER DEFAULT 0,
            APP_NAME VARCHAR(255),
            OAUTH_VERSION VARCHAR(128),
            CALLBACK_URL VARCHAR(1024),
            GRANT_TYPES VARCHAR (1024),
            PRIMARY KEY (CONSUMER_KEY)
);

DROP TABLE IF EXISTS IDN_OAUTH1A_REQUEST_TOKEN;
CREATE TABLE IDN_OAUTH1A_REQUEST_TOKEN (
            REQUEST_TOKEN VARCHAR(255),
            REQUEST_TOKEN_SECRET VARCHAR(512),
            CONSUMER_KEY VARCHAR(255),
            CALLBACK_URL VARCHAR(1024),
            SCOPE VARCHAR(2048),
            AUTHORIZED VARCHAR(128),
            OAUTH_VERIFIER VARCHAR(512),
            AUTHZ_USER VARCHAR(512),
            PRIMARY KEY (REQUEST_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

DROP TABLE IF EXISTS IDN_OAUTH1A_ACCESS_TOKEN;
CREATE TABLE IDN_OAUTH1A_ACCESS_TOKEN (
            ACCESS_TOKEN VARCHAR(255),
            ACCESS_TOKEN_SECRET VARCHAR(512),
            CONSUMER_KEY VARCHAR(255),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR(512),
            PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

DROP TABLE IF EXISTS IDN_OAUTH2_AUTHORIZATION_CODE;
CREATE TABLE IDN_OAUTH2_AUTHORIZATION_CODE (
            AUTHORIZATION_CODE VARCHAR(255),
            CONSUMER_KEY VARCHAR(255),
	        CALLBACK_URL VARCHAR(1024),
            SCOPE VARCHAR(2048),
            AUTHZ_USER VARCHAR(512),
	        TIME_CREATED TIMESTAMP,
	        VALIDITY_PERIOD BIGINT,
            PRIMARY KEY (AUTHORIZATION_CODE),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

DROP TABLE IF EXISTS IDN_OAUTH2_ACCESS_TOKEN;
CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN (
			ACCESS_TOKEN VARCHAR(255),
			REFRESH_TOKEN VARCHAR(255),
			CONSUMER_KEY VARCHAR(255),
			AUTHZ_USER VARCHAR(100),
			USER_TYPE VARCHAR (25),
			TIME_CREATED TIMESTAMP,
			VALIDITY_PERIOD BIGINT,
			TOKEN_SCOPE VARCHAR(2048),
			TOKEN_STATE VARCHAR(25) DEFAULT 'ACTIVE',
			TOKEN_STATE_ID VARCHAR (255) DEFAULT 'NONE',
			PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE,
            CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY, AUTHZ_USER,USER_TYPE,TOKEN_STATE,TOKEN_STATE_ID,TOKEN_SCOPE)
);

DROP TABLE IF EXISTS IDN_OAUTH2_SCOPE;
DROP SEQUENCE IF EXISTS IDN_OAUTH2_SCOPE_PK_SEQ;
CREATE SEQUENCE IDN_OAUTH2_SCOPE_PK_SEQ;
CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE (
            SCOPE_ID INTEGER DEFAULT NEXTVAL('idn_oauth2_scope_pk_seq'),
            SCOPE_KEY VARCHAR(100) NOT NULL,
            NAME VARCHAR(255) NULL,
            DESCRIPTION VARCHAR(512) NULL,
            TENANT_ID INTEGER NOT NULL,
	    ROLES VARCHAR (500) NULL,
            PRIMARY KEY (SCOPE_ID)
);

DROP TABLE IF EXISTS IDN_OAUTH2_RESOURCE_SCOPE;
CREATE TABLE IF NOT EXISTS IDN_OAUTH2_RESOURCE_SCOPE (
            RESOURCE_PATH VARCHAR(255) NOT NULL,
            SCOPE_ID INTEGER NOT NULL,
            PRIMARY KEY (RESOURCE_PATH),
            FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS IDN_SCIM_GROUP;
DROP SEQUENCE IF EXISTS IDN_SCIM_GROUP_PK_SEQ;
CREATE SEQUENCE IDN_SCIM_GROUP_PK_SEQ;
CREATE TABLE IDN_SCIM_GROUP (
			ID INTEGER DEFAULT NEXTVAL('idn_scim_group_pk_seq'),
			TENANT_ID INTEGER NOT NULL,
			ROLE_NAME VARCHAR(255) NOT NULL,
            ATTR_NAME VARCHAR(1024) NOT NULL,
			ATTR_VALUE VARCHAR(1024),
            PRIMARY KEY (ID)
);

DROP TABLE IF EXISTS IDN_SCIM_PROVIDER;
CREATE TABLE IDN_SCIM_PROVIDER (
            CONSUMER_ID VARCHAR(255) NOT NULL,
            PROVIDER_ID VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            USER_PASSWORD VARCHAR(255) NOT NULL,
            USER_URL VARCHAR(1024) NOT NULL,
			GROUP_URL VARCHAR(1024),
			BULK_URL VARCHAR(1024),
            PRIMARY KEY (CONSUMER_ID,PROVIDER_ID)
);

DROP TABLE IF EXISTS IDN_OPENID_REMEMBER_ME;
CREATE TABLE IDN_OPENID_REMEMBER_ME (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT 0,
            COOKIE_VALUE VARCHAR(1024),
            CREATED_TIME TIMESTAMP,
            PRIMARY KEY (USER_NAME, TENANT_ID)
);

DROP TABLE IF EXISTS IDN_OPENID_USER_RPS;
CREATE TABLE IDN_OPENID_USER_RPS (
			USER_NAME VARCHAR(255) NOT NULL,
			TENANT_ID INTEGER DEFAULT 0,
			RP_URL VARCHAR(255) NOT NULL,
			TRUSTED_ALWAYS VARCHAR(128) DEFAULT 'FALSE',
			LAST_VISIT DATE NOT NULL,
			VISIT_COUNT INTEGER DEFAULT 0,
			DEFAULT_PROFILE_NAME VARCHAR(255) DEFAULT 'DEFAULT',
			PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL)
);

DROP TABLE IF EXISTS IDN_OPENID_ASSOCIATIONS;
CREATE TABLE IDN_OPENID_ASSOCIATIONS (
			HANDLE VARCHAR(255) NOT NULL,
			ASSOC_TYPE VARCHAR(255) NOT NULL,
			EXPIRE_IN TIMESTAMP NOT NULL,
			MAC_KEY VARCHAR(255) NOT NULL,
			ASSOC_STORE VARCHAR(128) DEFAULT 'SHARED',
			PRIMARY KEY (HANDLE)
);

DROP TABLE IF EXISTS IDN_STS_STORE;
DROP SEQUENCE IF EXISTS IDN_STS_STORE_PK_SEQ;
CREATE SEQUENCE IDN_STS_STORE_PK_SEQ;
CREATE TABLE IDN_STS_STORE (
            ID INTEGER DEFAULT NEXTVAL('idn_sts_store_pk_seq'),
            TOKEN_ID VARCHAR(255) NOT NULL,
            TOKEN_CONTENT BYTEA NOT NULL,
            CREATE_DATE TIMESTAMP NOT NULL,
            EXPIRE_DATE TIMESTAMP NOT NULL,
            STATE INTEGER DEFAULT 0,
            PRIMARY KEY (ID)
);

DROP TABLE IF EXISTS IDN_IDENTITY_USER_DATA;
CREATE TABLE IDN_IDENTITY_USER_DATA (
            TENANT_ID INTEGER DEFAULT -1234,
            USER_NAME VARCHAR(255) NOT NULL,
            DATA_KEY VARCHAR(255) NOT NULL,
            DATA_VALUE VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, DATA_KEY)
);

DROP TABLE IF EXISTS IDN_IDENTITY_META_DATA;
CREATE TABLE IDN_IDENTITY_META_DATA (
            USER_NAME VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1234,
            METADATA_TYPE VARCHAR(255) NOT NULL,
            METADATA VARCHAR(255) NOT NULL,
            VALID VARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, METADATA_TYPE,METADATA)
);

DROP TABLE IF EXISTS IDN_THRIFT_SESSION;
CREATE TABLE IDN_THRIFT_SESSION (
            SESSION_ID VARCHAR(255) NOT NULL,
            USER_NAME VARCHAR(255) NOT NULL,
            CREATED_TIME VARCHAR(255) NOT NULL,
            LAST_MODIFIED_TIME VARCHAR(255) NOT NULL,
            PRIMARY KEY (SESSION_ID)
);

-- End of IDN Tables --


-- Start of IDN-APPLICATION-MGT Tables--
DROP TABLE IF EXISTS SP_APP;
DROP SEQUENCE IF EXISTS SP_APP_SEQ;
CREATE SEQUENCE SP_APP_SEQ;
CREATE TABLE SP_APP (
            ID INTEGER DEFAULT NEXTVAL('sp_app_seq'),
            TENANT_ID INTEGER NOT NULL,
	    	APP_NAME VARCHAR (255) NOT NULL ,
	    	USER_STORE VARCHAR (255) NOT NULL,
            USERNAME VARCHAR (255) NOT NULL ,
            DESCRIPTION VARCHAR (1024),
	    	ROLE_CLAIM VARCHAR (512),
            AUTH_TYPE VARCHAR (255) NOT NULL,
	    	PROVISIONING_USERSTORE_DOMAIN VARCHAR (512),
	    	IS_LOCAL_CLAIM_DIALECT CHAR(1) DEFAULT '1',
	    	IS_SEND_LOCAL_SUBJECT_ID CHAR(1) DEFAULT '0',
	    	IS_SEND_AUTH_LIST_OF_IDPS CHAR(1) DEFAULT '0',
	    	SUBJECT_CLAIM_URI VARCHAR (512),
	    	IS_SAAS_APP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID);

DROP TABLE IF EXISTS SP_INBOUND_AUTH;
DROP SEQUENCE IF EXISTS SP_INBOUND_AUTH_SEQ;
CREATE SEQUENCE SP_INBOUND_AUTH_SEQ;
CREATE TABLE SP_INBOUND_AUTH (
            ID INTEGER DEFAULT NEXTVAL('sp_inbound_auth_seq'),
	     	TENANT_ID INTEGER NOT NULL,
	     	INBOUND_AUTH_KEY VARCHAR (255) NOT NULL,
            INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL,
            PROP_NAME VARCHAR (255),
            PROP_VALUE VARCHAR (1024) ,
	     	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_INBOUND_AUTH ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS SP_AUTH_STEP;
DROP SEQUENCE IF EXISTS SP_AUTH_STEP_SEQ;
CREATE SEQUENCE SP_AUTH_STEP_SEQ;
CREATE TABLE SP_AUTH_STEP (
            ID INTEGER DEFAULT NEXTVAL('sp_auth_step_seq'),
            TENANT_ID INTEGER NOT NULL,
	     	STEP_ORDER INTEGER DEFAULT 1,
            APP_ID INTEGER NOT NULL,
            IS_SUBJECT_STEP CHAR(1) DEFAULT '0',
            IS_ATTRIBUTE_STEP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_AUTH_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS SP_FEDERATED_IDP;
CREATE TABLE SP_FEDERATED_IDP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PRIMARY KEY (ID, AUTHENTICATOR_ID));

ALTER TABLE SP_FEDERATED_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (ID) REFERENCES SP_AUTH_STEP (ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS SP_CLAIM_MAPPING;
DROP SEQUENCE IF EXISTS SP_CLAIM_MAPPING_SEQ;
CREATE SEQUENCE SP_CLAIM_MAPPING_SEQ;
CREATE TABLE SP_CLAIM_MAPPING (
	    	ID INTEGER DEFAULT NEXTVAL('sp_claim_mapping_seq'),
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_CLAIM VARCHAR (512) NOT NULL ,
            SP_CLAIM VARCHAR (512) NOT NULL ,
	   		APP_ID INTEGER NOT NULL,
	    	IS_REQUESTED VARCHAR(128) DEFAULT '0',
	    	DEFAULT_VALUE VARCHAR(255),
            PRIMARY KEY (ID));

ALTER TABLE SP_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS SP_ROLE_MAPPING;
DROP SEQUENCE IF EXISTS SP_ROLE_MAPPING_SEQ;
CREATE SEQUENCE SP_ROLE_MAPPING_SEQ;
CREATE TABLE SP_ROLE_MAPPING (
	    	ID INTEGER DEFAULT NEXTVAL('sp_role_mapping_seq'),
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_ROLE VARCHAR (255) NOT NULL ,
            SP_ROLE VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS SP_REQ_PATH_AUTHENTICATOR;
DROP SEQUENCE IF EXISTS SP_REQ_PATH_AUTH_SEQ;
CREATE SEQUENCE SP_REQ_PATH_AUTH_SEQ;
CREATE TABLE SP_REQ_PATH_AUTHENTICATOR (
	    	ID INTEGER DEFAULT NEXTVAL('sp_req_path_auth_seq'),
	    	TENANT_ID INTEGER NOT NULL,
	    	AUTHENTICATOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_REQ_PATH_AUTHENTICATOR ADD CONSTRAINT REQ_AUTH_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS SP_PROVISIONING_CONNECTOR;
DROP SEQUENCE IF EXISTS SP_PROV_CONNECTOR_SEQ CASCADE;
CREATE SEQUENCE SP_PROV_CONNECTOR_SEQ;
CREATE TABLE SP_PROVISIONING_CONNECTOR (
	    	ID INTEGER DEFAULT NEXTVAL('sp_prov_connector_seq'),
	    	TENANT_ID INTEGER NOT NULL,
            IDP_NAME VARCHAR (255) NOT NULL ,
	    	CONNECTOR_NAME VARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
	    	IS_JIT_ENABLED CHAR(1) NOT NULL DEFAULT '0',
		BLOCKING CHAR(1) NOT NULL DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_PROVISIONING_CONNECTOR ADD CONSTRAINT PRO_CONNECTOR_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS IDP;
DROP SEQUENCE IF EXISTS IDP_SEQ;
CREATE SEQUENCE IDP_SEQ;
CREATE TABLE IDP (
			ID INTEGER DEFAULT NEXTVAL('idp_seq'),
			TENANT_ID INTEGER,
			NAME VARCHAR(254) NOT NULL,
			IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
			IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
			HOME_REALM_ID VARCHAR(254),
			IMAGE BYTEA,
			CERTIFICATE BYTEA,
			ALIAS VARCHAR(254),
			INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
			INBOUND_PROV_USER_STORE_ID VARCHAR(254),
 			USER_CLAIM_URI VARCHAR(254),
 			ROLE_CLAIM_URI VARCHAR(254),
  			DESCRIPTION VARCHAR (1024),
 			DEFAULT_AUTHENTICATOR_NAME VARCHAR(254),
 			DEFAULT_PRO_CONNECTOR_NAME VARCHAR(254),
 			PROVISIONING_ROLE VARCHAR(128),
 			IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
 			IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
	                DISPLAY_NAME VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (TENANT_ID, NAME));

INSERT INTO IDP (TENANT_ID, NAME, HOME_REALM_ID) VALUES (-1234, 'LOCAL', 'localhost');

DROP TABLE IF EXISTS IDP_ROLE;
DROP SEQUENCE IF EXISTS IDP_ROLE_SEQ;
CREATE SEQUENCE IDP_ROLE_SEQ;
CREATE TABLE IDP_ROLE (
			ID INTEGER DEFAULT NEXTVAL('idp_role_seq'),
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			ROLE VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, ROLE),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_ROLE_MAPPING;
DROP SEQUENCE IF EXISTS IDP_ROLE_MAPPING_SEQ;
CREATE SEQUENCE IDP_ROLE_MAPPING_SEQ;
CREATE TABLE IDP_ROLE_MAPPING (
			ID INTEGER DEFAULT NEXTVAL('idp_role_mapping_seq'),
			IDP_ROLE_ID INTEGER,
			TENANT_ID INTEGER,
			USER_STORE_ID VARCHAR (253),
			LOCAL_ROLE VARCHAR(253),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
			FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_CLAIM;
DROP SEQUENCE IF EXISTS IDP_CLAIM_SEQ;
CREATE SEQUENCE IDP_CLAIM_SEQ;
CREATE TABLE IDP_CLAIM (
			ID INTEGER DEFAULT NEXTVAL('idp_claim_seq'),
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			CLAIM VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, CLAIM),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_CLAIM_MAPPING;
DROP SEQUENCE IF EXISTS IDP_CLAIM_MAPPING_SEQ;
CREATE SEQUENCE IDP_CLAIM_MAPPING_SEQ;
CREATE TABLE IDP_CLAIM_MAPPING (
			ID INTEGER DEFAULT NEXTVAL('idp_claim_mapping_seq'),
			IDP_CLAIM_ID INTEGER,
			TENANT_ID INTEGER,
			LOCAL_CLAIM VARCHAR(253),
		    DEFAULT_VALUE VARCHAR(255),
	    	IS_REQUESTED VARCHAR(128) DEFAULT '0',
			PRIMARY KEY (ID),
			UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
			FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_AUTHENTICATOR;
DROP SEQUENCE IF EXISTS IDP_AUTHENTICATOR_SEQ;
CREATE SEQUENCE IDP_AUTHENTICATOR_SEQ;
CREATE TABLE IDP_AUTHENTICATOR (
            ID INTEGER DEFAULT NEXTVAL('idp_authenticator_seq'),
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            NAME VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '1',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'saml2sso');

DROP TABLE IF EXISTS IDP_AUTHENTICATOR_PROP;
DROP SEQUENCE IF EXISTS IDP_AUTHENTICATOR_PROP_SEQ;
CREATE SEQUENCE IDP_AUTHENTICATOR_PROP_SEQ;
CREATE TABLE IDP_AUTHENTICATOR_PROPERTY (
            ID INTEGER DEFAULT NEXTVAL('idp_authenticator_prop_seq'),
            TENANT_ID INTEGER,
            AUTHENTICATOR_ID INTEGER,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2047),
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
            FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_PROV_CONFIG;
DROP SEQUENCE IF EXISTS IDP_PROV_CONFIG_SEQ;
CREATE SEQUENCE IDP_PROV_CONFIG_SEQ;
CREATE TABLE IDP_PROVISIONING_CONFIG (
            ID INTEGER DEFAULT NEXTVAL('idp_prov_config_seq'),
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            PROVISIONING_CONNECTOR_TYPE VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '0',
            IS_BLOCKING CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_PROV_CONFIG_PROP;
DROP SEQUENCE IF EXISTS IDP_PROV_CONFIG_PROP_SEQ;
CREATE SEQUENCE IDP_PROV_CONFIG_PROP_SEQ;
CREATE TABLE IDP_PROV_CONFIG_PROPERTY (
            ID INTEGER DEFAULT NEXTVAL('idp_prov_config_prop_seq'),
            TENANT_ID INTEGER,
            PROVISIONING_CONFIG_ID INTEGER,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2048),
            PROPERTY_BLOB_VALUE BLOB,
            PROPERTY_TYPE CHAR(32) NOT NULL,
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, PROVISIONING_CONFIG_ID, PROPERTY_KEY),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_PROV_ENTITY;
DROP SEQUENCE IF EXISTS IDP_PROV_ENTITY_SEQ;
CREATE SEQUENCE IDP_PROV_ENTITY_SEQ;
CREATE TABLE IDP_PROVISIONING_ENTITY (
            ID INTEGER DEFAULT NEXTVAL('idp_prov_entity_seq'),
            PROVISIONING_CONFIG_ID INTEGER,
            ENTITY_TYPE VARCHAR(255) NOT NULL,
            ENTITY_LOCAL_USERSTORE VARCHAR(255) NOT NULL,
            ENTITY_NAME VARCHAR(255) NOT NULL,
            ENTITY_VALUE VARCHAR(255),
            TENANT_ID INTEGER,
            PRIMARY KEY (ID),
            UNIQUE (ENTITY_TYPE, TENANT_ID, ENTITY_LOCAL_USERSTORE, ENTITY_NAME),
            UNIQUE (PROVISIONING_CONFIG_ID, ENTITY_TYPE, ENTITY_VALUE),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE);

DROP TABLE IF EXISTS IDP_LOCAL_CLAIM;
DROP SEQUENCE IF EXISTS IDP_LOCAL_CLAIM_SEQ;
CREATE SEQUENCE IDP_LOCAL_CLAIM_SEQ;
CREATE TABLE IF NOT EXISTS IDP_LOCAL_CLAIM(
            ID INTEGER DEFAULT NEXTVAL('idp_local_claim_seq'),
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            CLAIM_URI VARCHAR(255) NOT NULL,
            DEFAULT_VALUE VARCHAR(255),
	        IS_REQUESTED VARCHAR(128) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, CLAIM_URI),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

-- End of IDN-APPLICATION-MGT Tables--


CREATE SEQUENCE AM_SUBSCRIBER_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_SUBSCRIBER (
    SUBSCRIBER_ID INTEGER DEFAULT nextval('am_subscriber_sequence'),
    USER_ID VARCHAR(50) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    EMAIL_ADDRESS VARCHAR(256) NULL,
    DATE_SUBSCRIBED DATE NOT NULL,
    PRIMARY KEY (SUBSCRIBER_ID),
    UNIQUE (TENANT_ID,USER_ID)
)
;

CREATE SEQUENCE AM_APPLICATION_SEQUENCE START WITH 1 INCREMENT BY 1 ;
CREATE TABLE AM_APPLICATION (
    APPLICATION_ID INTEGER DEFAULT nextval('am_application_sequence'),
    NAME VARCHAR(100),
    SUBSCRIBER_ID INTEGER,
    APPLICATION_TIER VARCHAR(50) DEFAULT 'Unlimited',
    CALLBACK_URL VARCHAR(512),
    DESCRIPTION VARCHAR(512),
	APPLICATION_STATUS VARCHAR(50) DEFAULT 'APPROVED',
    FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY(APPLICATION_ID),
    UNIQUE (NAME,SUBSCRIBER_ID)
)
;

CREATE SEQUENCE AM_API_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_API (
    API_ID INTEGER DEFAULT nextval('am_api_sequence'),
    API_PROVIDER VARCHAR(256),
    API_NAME VARCHAR(256),
    API_VERSION VARCHAR(30),
    CONTEXT VARCHAR(256),
    PRIMARY KEY(API_ID),
    UNIQUE (API_PROVIDER,API_NAME,API_VERSION)
)
;

CREATE SEQUENCE AM_API_URL_MAPPING_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_API_URL_MAPPING (
    URL_MAPPING_ID INTEGER DEFAULT nextval('am_api_url_mapping_sequence'),
    API_ID INTEGER NOT NULL,
    HTTP_METHOD VARCHAR(20) NULL,
    AUTH_SCHEME VARCHAR(50) NULL,
    URL_PATTERN VARCHAR(512) NULL,
    THROTTLING_TIER varchar(512) DEFAULT NULL,
    MEDIATION_SCRIPT BYTEA,
    PRIMARY KEY(URL_MAPPING_ID)
)
;

CREATE SEQUENCE AM_SUBSCRIPTION_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_SUBSCRIPTION (
    SUBSCRIPTION_ID INTEGER DEFAULT nextval('am_subscription_sequence'),
    TIER_ID VARCHAR(50),
    API_ID INTEGER,
    LAST_ACCESSED DATE NULL,
    APPLICATION_ID INTEGER,
    SUB_STATUS VARCHAR(50),
    FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (SUBSCRIPTION_ID)
)
;

CREATE TABLE AM_SUBSCRIPTION_KEY_MAPPING (
    SUBSCRIPTION_ID INTEGER,
    ACCESS_TOKEN VARCHAR(512),
    KEY_TYPE VARCHAR(512) NOT NULL,
    FOREIGN KEY(SUBSCRIPTION_ID) REFERENCES AM_SUBSCRIPTION(SUBSCRIPTION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY(SUBSCRIPTION_ID,ACCESS_TOKEN)
)
;

CREATE TABLE AM_APPLICATION_KEY_MAPPING (
    APPLICATION_ID INTEGER,
    CONSUMER_KEY VARCHAR(512),
    KEY_TYPE VARCHAR(512) NOT NULL,
    STATE VARCHAR(30),
    FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY(APPLICATION_ID,KEY_TYPE)
)
;

CREATE SEQUENCE AM_APPLICATION_REGISTRATION_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE IF NOT EXISTS AM_APPLICATION_REGISTRATION (
    REG_ID INTEGER DEFAULT nextval('am_application_registration_sequence'),
    SUBSCRIBER_ID INT,
    WF_REF VARCHAR(255) NOT NULL,
    APP_ID INT,
    TOKEN_TYPE VARCHAR(30),
    ALLOWED_DOMAINS VARCHAR(256),
    VALIDITY_PERIOD BIGINT,
    UNIQUE (SUBSCRIBER_ID,APP_ID,TOKEN_TYPE),
    FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(APP_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (REG_ID)
)
;



CREATE SEQUENCE AM_API_LC_EVENT_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_API_LC_EVENT (
    EVENT_ID INTEGER DEFAULT nextval('am_api_lc_event_sequence'),
    API_ID INTEGER NOT NULL,
    PREVIOUS_STATE VARCHAR(50),
    NEW_STATE VARCHAR(50) NOT NULL,
    USER_ID VARCHAR(50) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    EVENT_DATE DATE NOT NULL,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (EVENT_ID)
)
;

CREATE TABLE AM_APP_KEY_DOMAIN_MAPPING (
   CONSUMER_KEY VARCHAR(255),
   AUTHZ_DOMAIN VARCHAR(255) DEFAULT 'ALL',
   PRIMARY KEY (CONSUMER_KEY,AUTHZ_DOMAIN),
   FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY)
)
;

CREATE SEQUENCE AM_API_COMMENTS_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_API_COMMENTS (
    COMMENT_ID INTEGER DEFAULT nextval('am_api_comments_sequence'),
    COMMENT_TEXT VARCHAR(512),
    COMMENTED_USER VARCHAR(255),
    DATE_COMMENTED DATE NOT NULL,
    API_ID INTEGER NOT NULL,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (COMMENT_ID)
)
;

CREATE SEQUENCE AM_WORKFLOWS_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_WORKFLOWS(
    WF_ID INTEGER DEFAULT nextval('am_workflows_sequence'),
    WF_REFERENCE VARCHAR(255) NOT NULL,
    WF_TYPE VARCHAR(255) NOT NULL,
    WF_STATUS VARCHAR(255) NOT NULL,
    WF_CREATED_TIME TIMESTAMP,
    WF_UPDATED_TIME TIMESTAMP,
    WF_STATUS_DESC VARCHAR(1000),
    TENANT_ID INTEGER,
    TENANT_DOMAIN VARCHAR(255),
    WF_EXTERNAL_REFERENCE VARCHAR(255) NOT NULL,
    PRIMARY KEY (WF_ID),
    UNIQUE (WF_EXTERNAL_REFERENCE)
)
;

CREATE SEQUENCE AM_API_RATINGS_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_API_RATINGS (
    RATING_ID INTEGER DEFAULT nextval('am_api_ratings_sequence'),
    API_ID INTEGER,
    RATING INTEGER,
    SUBSCRIBER_ID INTEGER,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (RATING_ID)
)
;

CREATE SEQUENCE AM_TIER_PERMISSIONS_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_TIER_PERMISSIONS (
    TIER_PERMISSIONS_ID INTEGER DEFAULT nextval('am_tier_permissions_sequence'),
    TIER VARCHAR(50) NOT NULL,
    PERMISSIONS_TYPE VARCHAR(50) NOT NULL,
    ROLES VARCHAR(512) NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY(TIER_PERMISSIONS_ID)
);

CREATE SEQUENCE AM_EXTERNAL_STORES_SEQUENCE START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_EXTERNAL_STORES (
    APISTORE_ID INTEGER DEFAULT nextval('am_external_stores_sequence'),
    API_ID INTEGER,
    STORE_ID VARCHAR(255) NOT NULL,
    STORE_DISPLAY_NAME VARCHAR(255) NOT NULL,
    STORE_ENDPOINT VARCHAR(255) NOT NULL,
    STORE_TYPE VARCHAR(255) NOT NULL,
    FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
    PRIMARY KEY (APISTORE_ID)
)
;

DROP TABLE IF EXISTS AM_API_SCOPES;
CREATE TABLE IF NOT EXISTS AM_API_SCOPES (
   API_ID  INTEGER NOT NULL,
   SCOPE_ID  INTEGER NOT NULL,
   FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE  ON UPDATE CASCADE,
   FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS AM_API_DEFAULT_VERSION;
DROP SEQUENCE IF EXISTS AM_API_DEFAULT_VERSION_PK_SEQ;
CREATE SEQUENCE AM_API_DEFAULT_VERSION_PK_SEQ;
CREATE TABLE AM_API_DEFAULT_VERSION (
            DEFAULT_VERSION_ID INTEGER DEFAULT NEXTVAL('am_api_default_version_pk_seq'), 
            API_NAME VARCHAR(256) NOT NULL ,
            API_PROVIDER VARCHAR(256) NOT NULL , 
            DEFAULT_API_VERSION VARCHAR(30) , 
            PUBLISHED_DEFAULT_API_VERSION VARCHAR(30) ,
            PRIMARY KEY (DEFAULT_VERSION_ID)
);


CREATE INDEX IDX_SUB_APP_ID ON AM_SUBSCRIPTION (APPLICATION_ID, SUBSCRIPTION_ID)
;
commit;
