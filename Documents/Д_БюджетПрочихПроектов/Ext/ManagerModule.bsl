﻿
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Документы.Д_БюджетПрочихПроектов.ПолучитьМакет("Печать");
	
	Если ТипЗнч(Ссылка) = Тип("Массив") Тогда
		ТекДок = Ссылка[0];
	Иначе
		ТекДок = Ссылка;
	КонецЕсли;
	
	КорректировочныйБюджет = РасчетыБюджет.ЭтоКорректировочныйБюджет(ТекДок.Сценарий);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Д_БюджетПрочихПроектов.Автор,
	|	Д_БюджетПрочихПроектов.Комментарий,
	|	Д_БюджетПрочихПроектов.Подразделение,
	|	Д_БюджетПрочихПроектов.Предприятие,
	|	Д_БюджетПрочихПроектов.Сценарий,
	|	Д_БюджетПрочихПроектов.Затраты.(
	|		НомерСтроки,
	|		Месяц,
	|		Признак,
	|		ЦФО,
	|		Подразделение,
	|		СтатьяЗатрат,
	|		СуммаСеб,
	|		СтатьяБДДС,
	|		СуммаБДДС,
	|		Основание
	|	),
	|	Д_БюджетПрочихПроектов.ЗатратыКП.(
	|		Ссылка,
	|		НомерСтроки,
	|		СтатьяЗатрат,
	|		ЛимитНаНачало,
	|		СуммаСеб,
	|		СуммаБДДС,
	|		СтатьяБДДС,
	|		Источник,
	|		Номенклатура,
	|		Основание,
	|		ВидДеятельности,
	|		Месяц,
	|		ЦФО,
	|		ИнвПроект,
	|		ЛимитНаНачалоДДС,
	|		НаЕдиницу,
	|		УИД,
	|		Бюджет,
	|		ВнесенаВБюджет,
	|		ВНХ
	|	)
	|ИЗ
	|	Документ.Д_БюджетПрочихПроектов КАК Д_БюджетПрочихПроектов
	|ГДЕ
	|	Д_БюджетПрочихПроектов.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", ТекДок);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	
	Если КорректировочныйБюджет Тогда
		ОбластьЗатратыШапка = Макет.ПолучитьОбласть("КорректировкиШапка");
		ОбластьЗатраты = Макет.ПолучитьОбласть("Корректировки");
	Иначе	
		ОбластьЗатратыШапка = Макет.ПолучитьОбласть("ЗатратыШапка");
		ОбластьЗатраты = Макет.ПолучитьОбласть("Затраты");
	КонецЕсли;
	
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьЗатратыШапка);
		
		Если КорректировочныйБюджет Тогда
			ВыборкаЗатраты = Выборка.ЗатратыКП.Выбрать();
		Иначе
			ВыборкаЗатраты = Выборка.Затраты.Выбрать();
		КонецЕсли;
	
		Пока ВыборкаЗатраты.Следующий() Цикл
			ОбластьЗатраты.Параметры.Заполнить(ВыборкаЗатраты);
			ТабДок.Вывести(ОбластьЗатраты, ВыборкаЗатраты.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
