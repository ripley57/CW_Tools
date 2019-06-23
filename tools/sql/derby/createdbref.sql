connect 'jdbc:derby:c:/temp/mydb;create=true';
drop table orders;
drop table custs;
create table custs(
    id char(5) not null, 
    name char(40) not null, 
    primary key(id)
);
create table orders(
    id char(8) not null,
    custid char(5) not null references custs(id) on delete cascade,
    total integer,
    primary key(id,custid)
);
insert into custs values ('1','John Smith');
insert into custs values ('2','Mary Todd');
insert into orders values ('0001','1',39999);
insert into orders values ('0002','1',2999);
insert into orders values ('0003','1',1904);
insert into orders values ('0004','2',3232);
insert into orders values ('0005','2',109900);
