create view jml_status_pintu_air as 
    select status_normal.nama_pintu_air, jml_status_normal, jml_status_rawan, jml_status_waspada, jml_status_kritis
    from
            (select distinct nama_pintu_air, count (status) as jml_status_waspada 
            from tinggi_permukaan_air_pintu_air where status = 'Waspada' group by nama_pintu_air, status) as status_waspada 
        inner join 
            (select distinct nama_pintu_air, count (status) as jml_status_normal 
            from tinggi_permukaan_air_pintu_air where status = 'Normal' group by nama_pintu_air,status) as status_normal on status_waspada.nama_pintu_air = status_normal.nama_pintu_air
        inner join 
            (select distinct nama_pintu_air, count (status) as jml_status_rawan 
            from tinggi_permukaan_air_pintu_air  where status = 'Rawan' group by nama_pintu_air, status) as status_rawan on status_normal.nama_pintu_air = status_rawan.nama_pintu_air 
        inner join 
            (select distinct nama_pintu_air, count (status) as jml_status_kritis
            from tinggi_permukaan_air_pintu_air where status = 'Kritis' group by nama_pintu_air, status) as status_kritis on status_rawan.nama_pintu_air = status_kritis.nama_pintu_air;

select*from jml_status_pintu_air;

hahahhaha


