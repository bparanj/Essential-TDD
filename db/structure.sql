CREATE TABLE "affiliates" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "referrer_code" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "bounties" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "affiliate_id" integer NOT NULL, "payable_id" integer, "product_price" decimal(11,2) NOT NULL, "currency" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "clicks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "affiliate_id" integer, "product_id" integer, "landing_page_id" integer, "referral_cookie" varchar(255), "domain" varchar(255), "ip_address" varchar(255), "referral_code" varchar(255), "payer_cookie" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "landing_pages" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "link" text, "name" varchar(255) DEFAULT '' NOT NULL, "product_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "product_id" integer, "item_name" varchar(255), "ip_address" varchar(255), "first_name" varchar(255), "last_name" varchar(255), "express_token" varchar(255), "express_payer_id" varchar(255), "buyer_email" text, "custom" varchar(255), "details" text, "number" varchar(15), "status" varchar(255) DEFAULT 'open', "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "payables" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "affiliate_id" integer NOT NULL, "amount" decimal(11,2) NOT NULL, "status" varchar(255) DEFAULT 'new' NOT NULL, "payout_id" integer, "start_date" datetime, "end_date" datetime, "paid_at" datetime, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "payments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "transaction_id" varchar(255), "gross" decimal(8,2), "currency" varchar(255), "amount" decimal(8,2), "payment_method" varchar(255), "description" varchar(255), "status" varchar(255), "test" varchar(255), "payer_email" varchar(255), "payment_date" varchar(255), "payer_id" varchar(255), "details" text, "invoice" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "payouts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "affiliate_id" integer NOT NULL, "amount" decimal(11,2) NOT NULL, "status" varchar(255) DEFAULT 'new' NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "products" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "price" decimal(11,2) NOT NULL, "name" varchar(255) NOT NULL, "user_id" integer NOT NULL, "file" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "refunds" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "transaction_id" varchar(255), "currency" varchar(255), "amount" decimal(8,2), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "tokens" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "confirmation_number" varchar(15), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "transactions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "order_id" integer, "transaction_id" varchar(255), "action" varchar(255), "amount" integer, "currency" varchar(255), "success" boolean, "authorization" varchar(255), "message" varchar(255), "details" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "primary_paypal_email" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20121130211221');

INSERT INTO schema_migrations (version) VALUES ('20121201024552');

INSERT INTO schema_migrations (version) VALUES ('20121201024555');

INSERT INTO schema_migrations (version) VALUES ('20121201024608');

INSERT INTO schema_migrations (version) VALUES ('20121201024841');

INSERT INTO schema_migrations (version) VALUES ('20121203212249');

INSERT INTO schema_migrations (version) VALUES ('20121205015730');

INSERT INTO schema_migrations (version) VALUES ('20121205015957');

INSERT INTO schema_migrations (version) VALUES ('20121207182721');

INSERT INTO schema_migrations (version) VALUES ('20121207183202');

INSERT INTO schema_migrations (version) VALUES ('20121211184316');

INSERT INTO schema_migrations (version) VALUES ('20121212192714');

INSERT INTO schema_migrations (version) VALUES ('20121215000902');