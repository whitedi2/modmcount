﻿
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Справочники.сабОтпускаСотрудников.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	сабОтпускаСотрудников.ДатаНачала,
	|	сабОтпускаСотрудников.ДатаОкончания,
	|	сабОтпускаСотрудников.ЗамещающийСогласовал,
	|	сабОтпускаСотрудников.КомментарийЗамещающего,
	|	сабОтпускаСотрудников.Наименование,
	|	ВЫБОР
	|		КОГДА сабОтпускаСотрудников.ОтпускникОтсутствуетВБазе
	|			ТОГДА сабОтпускаСотрудников.СотрудникОтпускник
	|		ИНАЧЕ сабОтпускаСотрудников.Пользователь
	|	КОНЕЦ КАК Пользователь,
	|	сабОтпускаСотрудников.ПользовательСогласовал,
	|	сабОтпускаСотрудников.Примечания,
	|	сабОтпускаСотрудников.ДопСогласование.(
	|		Пользователь,
	|		Пройден,
	|		Согласовано,
	|		КомментарииПользователя,
	|		СубъектСогласования
	|	),
	|	сабОтпускаСотрудников.Пользователь КАК Пользователь1,
	|	сабОтпускаСотрудников.Замещающий,
	|	сабОтпускаСотрудников.ТипСогласования,
	|	сабОтпускаСотрудников.ДокОснование
	|ИЗ
	|	Справочник.сабОтпускаСотрудников КАК сабОтпускаСотрудников
	|ГДЕ
	|	сабОтпускаСотрудников.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСогласованиеШапка = Макет.ПолучитьОбласть("СогласованиеШапка");
	ОбластьСогласование = Макет.ПолучитьОбласть("Согласование");
	ОбластьПрикрепление = Макет.ПолучитьОбласть("Прикрепление");
	
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ОбластьЗаголовок.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());
		
		Если Не ПустаяСтрока(Выборка.ДокОснование) Тогда
			ОбластьПрикрепление.Параметры.Вложение = Строка(Выборка.ДокОснование);
			ОбластьПрикрепление.Параметры.РасшифровкаВложение = Новый Структура("Файл", Выборка.ДокОснование);
			ТабДок.Вывести(ОбластьПрикрепление);		
		КонецЕсли;
		
		
		ТабДок.Вывести(ОбластьСогласованиеШапка);
		ВыборкаСогласование = Выборка.ДопСогласование.Выбрать();
		Пока ВыборкаСогласование.Следующий() Цикл
			ОбластьСогласование.Параметры.Заполнить(ВыборкаСогласование);
			ОбластьСогласование.Параметры.Пользователь = ВыборкаСогласование.СубъектСогласования;
			ТабДок.Вывести(ОбластьСогласование, ВыборкаСогласование.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
