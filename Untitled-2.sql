create jml_status_pintu_air as 

select nama_pintu_air,
count(Status) filter(where Status = 'Normal') as jml_status_normal,
count(Status) filter(where Status = 'Rawan') as jml_status_rawan,
count(Status) filter(where Status = 'Waspada') as jml_status_waspada,
count(Status) filter(where Status = 'Kritis') as jml_status_kritis
from tinggi_permukaan_air_pintu_air group by nama_pintu_air;

select*from jml_status_pintu_air;