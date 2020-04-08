haihai
sdfsdf
with jml_wna as
(Select nama_kecamatan, sum(laki_laki_wna+perempuan_wna) as jmlwna
    from jumlah_penduduk group by nama_kecamatan),
rerata_wna as
(select nama_kecamatan, avg(laki_laki_wna+perempuan_wna) as rerata_wna
    from jumlah_penduduk group by nama_kecamatan),
jml_penduduk as
(select nama_kecamatan, sum(laki_laki_wna+perempuan_wna + laki_laki_wni + perempuan_wni) as jmlpenduduk
    from jumlah_penduduk group by nama_kecamatan),
rerata_penduduk as
(select nama_kecamatan, avg(laki_laki_wna+perempuan_wna + laki_laki_wni + perempuan_wni) as rerata_penduduk
    from jumlah_penduduk group by nama_kecamatan)

Select distinct nama_kecamatan
    From jml_wna natural join rerata_wna natural join jml_penduduk natural join rerata_penduduk 
    Where jml_wna.jmlwna > rerata_wna.rerata_wna and jml_penduduk.jmlpenduduk < rerata_penduduk.rerata_penduduk;
