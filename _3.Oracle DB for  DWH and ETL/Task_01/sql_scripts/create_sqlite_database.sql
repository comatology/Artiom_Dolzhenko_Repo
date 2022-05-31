drop table if exists t_ordered_items;
CREATE TABLE t_ordered_items ( 
                                                ORDERED_ITEMS_SURR_ID INT NOT NULL, 
                                                COLUMN1_INT INT NOT NULL,  
                                                COLUMN2_INT INT NOT NULL,  
                                                COLUMN3_INT INT NOT NULL,  
                                                COLUMN4_INT INT NOT NULL,  
                                                COLUMN5_INT INT NOT NULL,  
                                                COLUMN6_INT INT NOT NULL,  
                                                COLUMN7_INT INT NOT NULL,   
                                                COLUMN8_INT INT NOT NULL,  
                                                COLUMN9_INT INT NOT NULL,  
                                                COLUMN10_INT INT NOT NULL,  
                                                MEMBER TEXT NULL ,  
                                                INSERT_DATE DATE NOT NULL ,  
												CONSTRAINT columns_ordered_items    
                                                PRIMARY KEY (ORDERED_ITEMS_SURR_ID, MEMBER) );
CREATE UNIQUE INDEX columns_ordered_items ON t_ordered_items (ORDERED_ITEMS_SURR_ID, MEMBER);
									