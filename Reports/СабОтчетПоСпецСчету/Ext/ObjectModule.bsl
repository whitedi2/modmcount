﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВедетсяУчетПоВалютам", БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет());
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Рубль", Константы.ВалютаРегламентированногоУчета.Получить());
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
КонецПроцедуры
