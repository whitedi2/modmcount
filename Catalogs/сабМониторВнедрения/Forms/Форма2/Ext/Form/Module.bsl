﻿
&НаКлиенте
Процедура Автозаполнение(Команда)
	ВыполнитьАвтозаполение();
	Объект.Выполнено = Истина;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьАвтозаполение()
	
	УстановитьПривилегированныйРежим(Истина);
	
	БюджетныйНаСервере.НачальноеЗаполнениеИБ();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтруктуруПредприятия(Команда)
	ОткрытьФорму("Справочник.СтруктураПредприятия.Форма.сабФормаСписка",,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьСоответствиеПредприятий(Команда)
	ОткрытьФорму("РегистрСведений.сабСоответствияОрганизацийПредприятиям.ФормаСписка",,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьСтатусыНастроек", Новый Структура("Ссылка, Наименование, Выполнено", Объект.Ссылка, Объект.Наименование, Объект.Выполнено));
КонецПроцедуры

