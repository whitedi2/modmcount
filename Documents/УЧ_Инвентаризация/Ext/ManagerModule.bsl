
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	РеквизитыДокумента = БюджетныйНаСервере.ВернутьРеквизиты(Данные.Ссылка, "ВидОперации");
	Если НЕ РеквизитыДокумента = Неопределено И ЗначениеЗаполнено(РеквизитыДокумента.ВидОперации) Тогда
		Представление = Строка(РеквизитыДокумента.ВидОперации) + " " + Строка(Данные.Номер) + " от " + Строка(Данные.Дата);	
	КонецЕсли;
	
КонецПроцедуры
