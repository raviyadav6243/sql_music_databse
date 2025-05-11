--EASY LEVEL QUESTION

--QUESTION 1:  WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE?
SELECT * FROM employee
ORDER BY levels desc
limit 1

--QUESTION 2: WHICH COUNTRY HAS THE MOST INVOICE?
SELECT COUNT(*) as c , billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY  c desc

--QUESTION 3: WHAT ARE TOP 3 VALUES OF TOTAL INVOICE
SELECT total FROM invoice
ORDER BY total desc
limit 3

-- QUESTION 4: WHICH CITY HAS THE BEST CUSTOMERS?WE WOULD LIKE TO THROW A PROMOTIONAL MUSIC FESTIVAL IN THE CITY WE MADE LIKE THE MOST
--MONEY.WRITE A QUERY THAT RETURNS ONE CITY THAT HAS THE HIGHEST SUMOF INVOICCE
--TOTAL.RETURN BOTH THE CITY NAME & SUM OF ALL INVOICE TOTALS

SELECT SUM(total) as invoice_total,billing_city
FROM invoice
group by billing_city
order by invoice_total desc

--QUESTION 5: WHO IS THE BEST CUSTOMER?THE CUSTOMER WHO HAS SPENT THE MOST
--MONEY WILL BE DECLARED THE BEST CUSTOMER.WRITE A QUERY THAT RETURN THE PERSON WHO HAS SPENT THE 
--MOST MONEY.

SELECT customer.customer_id, customer.first_name , customer.last_name ,sum(invoice.total)as total
FROM customer
join invoice on customer.customer_id = invoice_id
group by customer.customer_id
order by total desc
limit 1

--MODERATE LEVEL QUESTION

--QUESTION 6: WRITE QUERY TO RETURN THE EMAIL,FIRST NAME,LAST NAME,&GENRE OF ALL ROCK MUSIC
--LISTENERS.RETURN YOUR LIST ORDERED ALPHABETICALLY BY EMAIL STARTING WITH A

select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
       select track_id from track
	   join genre on track.genre_id = genre.genre_id
	   where genre.name like 'ROCK'
)
order by email;

--QUESTION 7: LET'S INVITE THE ARTIST WHO HAVE WRITTEN THE MOST ROCK MUSIC IN OUR DATASET.WRITE A QUERY THAT RETURNS THE 
--ARTIST NAME AND TOTAL TRACK COUNT OF THE TOP 10 ROCK BANDS.
SELECT artist.artist_id ,artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;


--QUESTION 8: RETURN ALL THE TRACK NMAES THAT HAVE A SONG LENGHT LONGER THAN THE AVERAGE SONG LENGTH.
--RETURN THE NAME AND MILISECONDS FOR EACH TRACK.ORDER BY THE SONG LENGTH WITH THE LONGEST 
--SONG LISTED FIRST.

select name,milliseconds
from track
where milliseconds> (
     select avg(milliseconds) as avg_track_length
	 from track)
	order by milliseconds desc ;

--HARD LEVEL QUESTION

--QUESTION 9: FIND HOW MUCH AMOUNNT SPENT BY EACH CUSTOMER ON ARTIST? WRITE A 
--QUESRY TO RETURN CUSTOMER NAME,ARTIST NAME AND TOTAL SPENT

with best_selling_artist as(
      select artist.artist_id as artist_id,artist.name as artist_name,
	  sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	  from invoice_line
	  join track on track.track_id = invoice_line.track_id
	  join album on album.album.album_id = track.album_id
	  group by 1
	  order by 3 desc
	  limit 1
)

select c.customer_id , c.first_name , c.last_name , bsa.artist_name ,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc ;














