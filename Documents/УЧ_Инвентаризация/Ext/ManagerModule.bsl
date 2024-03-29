﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	РеквизитыДокумента = БюджетныйНаСервере.ВернутьРеквизиты(Данные.Ссылка, "ВидОперации");
	Если НЕ РеквизитыДокумента = Неопределено И ЗначениеЗаполнено(РеквизитыДокумента.ВидОперации) Тогда
		Представление = Строка(РеквизитыДокумента.ВидОперации) + " " + Строка(Данные.Номер) + " от " + Строка(Данные.Дата);	
	КонецЕсли;
	
КонецПроцедуры

Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Документы.УЧ_Инвентаризация.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УЧ_Инвентаризация.Дата,
	|	УЧ_Инвентаризация.Номер,
	|	УЧ_Инвентаризация.Организация,
	|	УЧ_Инвентаризация.Предприятие,
	|	УЧ_Инвентаризация.Склад,
	|	УЧ_Инвентаризация.Товары.(
	|		НомерСтроки,
	|		Номенклатура,
	|		КоличествоФакт,
	|		СуммаФакт,
	|		Количество,
	|		Сумма,
	|		КоличествоОтклонение,
	|		СуммаОтклонение,
	|		КоличествоБУ,
	|		СуммаБУ,
	|		КоличествоОтклонениеБУ,
	|		СуммаОтклонениеБУ
	|	)
	|ИЗ
	|	Документ.УЧ_Инвентаризация КАК УЧ_Инвентаризация
	|ГДЕ
	|	УЧ_Инвентаризация.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьТоварыШапка = Макет.ПолучитьОбласть("ТоварыШапка");
	ОбластьТовары = Макет.ПолучитьОбласть("Товары");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьТоварыШапка);
		ВыборкаТовары = Выборка.Товары.Выбрать();
		Пока ВыборкаТовары.Следующий() Цикл
			ОбластьТовары.Параметры.Заполнить(ВыборкаТовары);
			ТабДок.Вывести(ОбластьТовары, ВыборкаТовары.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
