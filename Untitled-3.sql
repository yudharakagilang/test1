
count(Status) filter(where Status = 'Normal') as jml_status_normal,
count(Status) filter(where Status = 'Rawan') as jml_status_rawan,
count(Status) filter(where Status = 'Waspada') as jml_status_waspada,
count(Status) filter(where Status = 'Kritis') as jml_status_kritis






create view Rasio_pintu_air as
select nama_pintu_air,
    (cast(jml_status_normal as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada)) as Rasio_normal,
    (cast(jml_status_rawan as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada))as Rasio_rawan,
    (cast(jml_status_waspada as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada))as Rasio_waspada,
    (cast(jml_status_kritis as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada))as Rasio_kritis

from jml_status_pintu_air;

select*from Rasio_pintu_air;




with Rasio_pintu_air as 
   (select nama_pintu_air,
    (cast(jml_status_normal as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada)) as Rasio_normal,
    (cast(jml_status_rawan as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada))as Rasio_rawan,
    (cast(jml_status_waspada as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada))as Rasio_waspada,
    (cast(jml_status_kritis as float)/(jml_status_kritis+jml_status_normal+jml_status_rawan+jml_status_waspada))as Rasio_kritis
    from jml_status_pintu_air)
select nama_pintu_air, text 'Rasio Normal Paling Tinggi' as Stat from Rasio_pintu_air
    where Rasio_normal=(select max(Rasio_normal) from Rasio_pintu_air)
union select nama_pintu_air, text 'Rasio Rawan Paling Tinggi' as Stat from Rasio_pintu_air
    where Rasio_rawan=(select max(Rasio_rawan) from Rasio_pintu_air)
union select nama_pintu_air, text 'Rasio Waspada Paling Tinggi' as Stat from Rasio_pintu_air
    where Rasio_waspada=(select max(Rasio_waspada) from Rasio_pintu_air)
union select nama_pintu_air, text 'Rasio Kritis Paling Tinggi' as Stat from Rasio_pintu_air
    where Rasio_kritis=(select max(Rasio_kritis) from Rasio_pintu_air);



select nama_pintu_air, extract('year'from tanggal) as year,
 extract('month'from tanggal) as month,
min(tinggi_air) as min_tinggi_air,
max(tinggi_air) as max_tinggi_air,
(max(tinggi_air)-min(tinggi_air))as selisih_tinggi_air
from tinggi_permukaan_air_pintu_air group by nama_pintu_air,year,month;


  create view ketinggian_air_min_max as
  select nama_pintu_air, extract (month from tanggal) as bulan,extract (year from tanggal) as tahun,
  min(tinggi_air) as min_tinggi_air,
  max(tinggi_air) as max_tinggi_air,
  (max(tinggi_air) - min(tinggi_air)) as tinggi_air_selisih
  from tinggi_permukaan_air group by nama_pintu_air,bulan,tahun;
  select * from ketinggian_air_min_max;



select nama_pintu_air, a.tahun,a.selisih
from  ketinggian_air_min_max,
(select tahun,max(tinggi_air_selisih) as selisih from ketinggian_air_min_max group by tahun) a
where ketinggian_air_min_max.tahun=a.tahun and ketinggian_air_min_max.selisih=a.selisih
order by a.tahun;


// no 3b

create view selisih as
select nama_kecamatan, abs(sum(perempuan_wni + perempuan_wna - laki_laki_wni - laki_laki_wna)) as selisih_pend
from jumlah_penduduk group by nama_kecamatan;

create view rerata as
(Select avg(selisih_pend) as rerata_selisih from selisih);

explain analyze
select selisih.nama_kecamatan
from selisih, rerata
where selisih.selisih_pend < rerata.rerata_selisih;


explain analyze
with selisih as (select nama_kecamatan, abs((sum((laki_laki_wni+laki_laki_wna)-(perempuan_wni+perempuan_wna)))) as selisih_pend
from jumlah_penduduk
group by nama_kecamatan), rerata as (select avg(selisih_pend) as rerata_selisih from selisih)
select nama_kecamatan from selisih,rerata
where rerata_selisih>selisih_pend;



//==================6b


select nama_pintu_air,a.tahun,a.tinggi_air_selisih
    from ketinggian_air_min_max b,
    (select tahun,max(tinggi_air_selisih) as tinggi_air_selisih
    from ketinggian_air_min_max
    group by tahun) a
where b.tahun=a.tahun and b.tinggi_air_selisih=a.tinggi_air_selisih order by a.tahun;



///=========================6 c
with a_selisih AS (
select tahun, 
MAX(ketinggian_air_min_max.tinggi_air_selisih) AS selisih_maks from ketinggian_air_min_max group by tahun),
selisih_tertinggi_setiap_tahun AS (select nama_pintu_air, tahun, a_selisih.selisih_maks
from ketinggian_air_min_max inner join a_selisih using(tahun)
where ketinggian_air_min_max.tinggi_air_selisih = a_selisih.selisih_maks
order by tahun),
b_selisih AS (
select nama_pintu_air, count(nama_pintu_air) as jml_nama_pintuair from selisih_tertinggi_setiap_tahun
group by nama_pintu_air ) select nama_pintu_air, jml_nama_pintuair
from b_selisih
where (b_selisih.jml_nama_pintuair = (select MAX(b_selisih.jml_nama_pintuair) from b_selisih));






