# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table order_entry (
  id                        bigint not null,
  type                      varchar(255),
  carrier                   varchar(255),
  entity_code               varchar(255),
  seat_type                 varchar(255),
  ref_url                   varchar(255),
  created_at                timestamp,
  matched_at                timestamp,
  price                     integer,
  quantity                  integer,
  constraint pk_order_entry primary key (id))
;

create sequence order_entry_seq;




# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists order_entry;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists order_entry_seq;

