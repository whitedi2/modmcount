﻿
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.Наименование = Формат(Объект.ДатаПроизводства, "ДФ=dd.MM.yyyy");
	Если Объект.Наименование = "" Тогда
		Объект.Наименование = "<Без серии>";	
	КонецЕсли;
КонецПроцедуры
