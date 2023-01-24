-- Storage of Beale cipher sentence
create table if not exists m_beale_cipher(
                                             page_num int not null,
                                             col_order int not null,
                                             col_value int not null,
                                             primary key(page_num, col_order)
    ) engine = InnoDB
;

--

