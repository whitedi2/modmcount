﻿
&НаКлиенте
Процедура УУ_ПослеЗаписиПосле(ПараметрыЗаписи)
	Оповестить("ОбновитьОбработкуЗаявок");
КонецПроцедуры

&НаКлиенте
Процедура УУ_ПриОткрытииПеред(Отказ)
	Отказ = сабОперОбщегоНазначенияНаКлиенте.ПроверкаСозданияНаОснованииНаКлиенте(Объект);
	Если Отказ Тогда
		Возврат;	
	КонецЕсли; 
КонецПроцедуры
