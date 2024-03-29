create table "user" (
"login" varchar(50) not null primary key,
"password" varchar(20) not null,
"email" varchar(50) not null unique,
"admin" boolean,
"created" date default current_timestamp,
"last_logged" date default current_timestamp
);

create trigger add_user_page after insert on user
   begin
      insert into user_page (user_login) values (new.login);
   end;

create table "user_page" (
"user_login" varchar(50) not null,
"content" longtext,
"content_html" longtext,
foreign key ("user_login") references user("login")
);

create table "template" (
"id" integer not null primary key autoincrement,
"filename" varchar(512) not null unique,
"description" longtext not null
);

create table "comment" (
"id" integer not null primary key autoincrement,
"date" date default current_timestamp,
"parent" integer null,
"user_login" varchar(50) null,
"anonymous_user" vachar(50) null,
"comment" longtext not null,
"photo_id" integer null,
foreign key ("photo_id") references photo("id"),
foreign key ("user_login") references user("login"),
foreign key ("parent") references comment("id")
);

create table "forum" (
"id" integer not null primary key autoincrement,
"name" varchar(100) not null,
"anonymity" boolean default TRUE,
"for_photo" boolean default TRUE
);

create table "category" (
"id" integer not null primary key autoincrement,
"forum_id" integer not null,
"name" varchar(100) not null,
foreign key ("forum_id") references post("id")
);

create table "photo" (
"id" integer not null primary key autoincrement,
"filename" varchar(512) unique,
"height" integer,
"width" integer,
"size" integer
);

create trigger add_user_photo_queue after insert on user
   begin
      insert into user_photo_queue (user_login) values (new.login);
   end;

create table "user_photo_queue" (
"user_login" varchar(50) not null,
"photo_id" integer,
foreign key ("user_login") references user("login"),
foreign key ("photo_id") references photo("id")
);


create table "post" (
"id" integer not null primary key autoincrement,
"name" varchar(100) not null,
"photo_id" integer,
"comment" longtext,
"category_id" integer not null,
"date_post" date default current_timestamp,
"last_comment_id" integer,
"template_id" integer not null,
"visit_counter" integer not null,
"comment_counter" integer not null,
"hidden" boolean default FALSE,
foreign key ("category_id") references category("id"),
foreign key ("last_comment_id") references comment("id"),
foreign key ("template_id") references template_id("id"),
foreign key ("photo_id") references photo("id")
);

create table "post_comment" (
"post_id" integer not null,
"comment_id" integer not null unique,
foreign key ("post_id") references post("id"),
foreign key ("comment_id") references comment("id")
);

--  Comment counter

create trigger update_comment_counter insert on post_comment
   begin
      update post set comment_counter=comment_counter + 1 where id = new.post_id;
   end;

create table "user_post" (
"user_login" varchar(50) not null,
"post_id" integer not null,
foreign key ("post_id") references post("id"),
foreign key ("user_login") references user("login")
);

create table "photo_metadata" (
"photo_id" integer not null,
"geo_latitude" real not null,
"geo_longitude" real not null,
"geo_latitude_formatted" varchar(20) not null,
"geo_longitude_formatted" varchar(2) not null,
foreign key ("photo_id") references photo("id")
);

create table "photo_exif" (
"photo_id" integer not null,
"create_date" varchar(19),
"make" varchar(50),
"camera_model_name" varchar(20),
"shutter_speed_value" varchar(10),
"aperture_value" varchar(10),
"flash" varchar(20),
"focal_length" varchar(10),
"exposure_mode" varchar(10),
"exposure_program" varchar(20),
"white_balance" varchar(10),
"metering_mode" varchar(20),
"iso" integer,
foreign key ("photo_id") references photo("id")
);

create table "criteria" (
"id" integer not null primary key autoincrement,
"name" varchar(100) not null
);

create table "rating" (
"user_login" varchar(50) null,
"post_id" integer not null,
"criteria_id" integer not null,
"post_rating" integer not null,
foreign key ("user_login") references user("login"),
foreign key ("post_id") references post("id"),
foreign key ("criteria_id") references criteria("id"),
primary key ("user_login", "post_id", "criteria_id")
);

create table global_rating (
"post_id" integer not null,
"criteria_id" integer not null,
"nb_vote" integer not null,
"post_rating_ponderated" integer not null,
"post_rating" integer not null,
"controversial_level" integer not null,
foreign key ("post_id") references post("id"),
foreign key ("criteria_id") references criteria("id"),
primary key ("post_id", "criteria_id")
);

create trigger initialize_global_rating after insert on post
begin
   insert into global_rating (post_id, criteria_id, nb_vote, post_rating_ponderated, post_rating, controversial_level)
             select new.id, id, 0, 0, 0, 0 from criteria;
end;

create trigger update_global_rating after insert on rating
begin
  update global_rating set post_rating=
    (select avg(post_rating) from rating
        where criteria_id = new.criteria_id and post_id = new.post_id),
      nb_vote=nb_vote+1
      where criteria_id = new.criteria_id and post_id = new.post_id;
  update global_rating set post_rating_ponderated=post_rating*nb_vote,
               controversial_level=(select sum(abs(r.post_rating - g.post_rating)) from rating r , global_rating g
                            where g.criteria_id = new.criteria_id and g.post_id = new.post_id
                            and r.criteria_id = new.criteria_id and r.post_id = new.post_id)
      where criteria_id = new.criteria_id and post_id = new.post_id;
end;

create trigger re_update_global_rating after update on rating
begin
  update global_rating set post_rating=
    (select avg(post_rating) from rating
        where criteria_id = new.criteria_id and post_id = new.post_id)
      where criteria_id = new.criteria_id and post_id = new.post_id;
  update global_rating set post_rating_ponderated=post_rating*nb_vote,
               controversial_level=(select sum(abs(r.post_rating - g.post_rating)) from rating r , global_rating g
                            where g.criteria_id = new.criteria_id and g.post_id = new.post_id
                            and r.criteria_id = new.criteria_id and r.post_id = new.post_id)
      where criteria_id = new.criteria_id and post_id = new.post_id;
end;
