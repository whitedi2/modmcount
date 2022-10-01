﻿//Функция делает расчет по 90 и 91 счетам на прошлый месяц по нужному (актуальному сценарию
//если в справочнике СценарииПланирования не найден реквизит АктуальнаяДата, совпадающая с датой прошлого месяца,
//то берется текущий сценарий документа как прошломесячный. Возвращает массив из 10 элементов
//Столбец1 - Актуальный Сценарий
//Столбец2 - ТипУчредителя
//Столбец3 - Сумма начисления по 75.2
&НаСервере
Функция РассчитатьПрибыльПрошлогоМесяца(Ссылка) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СценарииПланирования.Ссылка
	               |ИЗ
	               |	Справочник.СценарииПланирования КАК СценарииПланирования
	               |ГДЕ
	               |	СценарииПланирования.АктуальнаяДата МЕЖДУ &Дата1 И &Дата2";
	
	
	ПроверкаСценарий = Новый Массив;
	ПроверкаСценарий.Добавить(ПланыСчетов.Учетный.Счет90());
	ПроверкаСценарий.Добавить(ПланыСчетов.Учетный.Счет91());
	
	Дата1 = НачалоМесяца(ДобавитьМесяц(Ссылка.Дата, -1));
	
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Дата2", КонецМесяца(Дата1));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		АктуальныйСценарий = Выборка.Ссылка;
	иначе
		АктуальныйСценарий = Ссылка.Сценарий;	
	КонецЕсли;

	
	
	//считаем обороты по счетам 75.2 и 99
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БюджетныйОбороты1.Субконто1.ТипУчредителя КАК ТипУчредителя,
	               |	СУММА(-ЕСТЬNULL(БюджетныйОбороты1.СуммаОборот, 0)) КАК Сумма
	               |ИЗ
	               |	РегистрБухгалтерии.Бюджетный.Обороты(
	               |			&Дата1,
	               |			&Дата2,
	               |			,
	               |			Счет В ИЕРАРХИИ (&Счет1),
	               |			,
	               |			СценарийПлана = &СценарийПлана
	               |				И Предприятия = &Предприятие,
	               |			КорСчет В ИЕРАРХИИ (&Счет2),
	               |			) КАК БюджетныйОбороты1
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	БюджетныйОбороты1.Субконто1.ТипУчредителя
	               |АВТОУПОРЯДОЧИВАНИЕ";
	

	Запрос.УстановитьПараметр("СценарийПлана", АктуальныйСценарий);
	Запрос.УстановитьПараметр("Предприятие", Ссылка.Предприятие);
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Дата2", КонецМесяца(Дата1));
	Запрос.УстановитьПараметр("Счет1", ПланыСчетов.Учетный.Счет7502());
    Запрос.УстановитьПараметр("Счет2", ПланыСчетов.Учетный.Счет99());
	
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
		
	СтруктураВозврата = Новый Массив(10,3);
	СтруктураВозврата[0][0] = АктуальныйСценарий; 
	СтруктураВозврата[0][2] = 0;
	Строчка = 0;
	Пока Выборка.Следующий() Цикл
		СтруктураВозврата[Строчка][0] = АктуальныйСценарий;
		СтруктураВозврата[Строчка][1] = Выборка.ТипУчредителя;
		СтруктураВозврата[Строчка][2] = Выборка.Сумма;
		Строчка = Строчка + 1;
	КонецЦикла;
	Возврат СтруктураВозврата;
	
КонецФункции // ()

// Функция - Получить данные из оперативных бюджетов
//
// Параметры:
//  Сценарий		 - 	сценарий плана 
//  Предприятие		 - 	предприятие 
//  Бюджет			 - 	бюджетный документ 
//  Корректировка	 - 	признак корректировки, если истина, берем данные из табличной части ЗатратыКП, если Ложь - из табличной части Затраты 
// Возвращаемое значение:
//   -  таблица значений 
&НаСервере
Функция ПолучитьДанныеИзОперативныхБюджетов(Сценарий, Предприятие, Бюджет, Корректировка, ТолькоВнесенные = Ложь, АктуальныйПериод = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивБюджетов = Новый Массив;
	
	Если ТипЗнч(Бюджет) = Тип("ДокументСсылка.Д_Бюджет") Тогда
		МассивБюджетов.Добавить(Бюджет)
	Иначе
		МассивБюджетов = Бюджет;
	КонецЕсли;
	
	Запрос = Новый Запрос;	
	
	Если Не Корректировка Тогда	
		Запрос.Текст = "ВЫБРАТЬ
		               |	Д_БюджетПрочихПроектовЗатраты.Ссылка,
		               |	Д_БюджетПрочихПроектовЗатраты.НомерСтроки,
		               |	Д_БюджетПрочихПроектовЗатраты.Признак,
		               |	Д_БюджетПрочихПроектовЗатраты.СтатьяЗатрат,
		               |	Д_БюджетПрочихПроектовЗатраты.СуммаСеб,
		               |	Д_БюджетПрочихПроектовЗатраты.СуммаБДДС,
		               |	Д_БюджетПрочихПроектовЗатраты.СтатьяБДДС,
		               |	Д_БюджетПрочихПроектовЗатраты.Источник,
		               |	Д_БюджетПрочихПроектовЗатраты.Подразделение,
		               |	Д_БюджетПрочихПроектовЗатраты.Основание,
		               |	Д_БюджетПрочихПроектовЗатраты.ЦФО,
		               |	Д_БюджетПрочихПроектовЗатраты.Месяц,
		               |	Д_БюджетПрочихПроектовЗатраты.УИД,
		               |	Д_БюджетПрочихПроектовЗатраты.Бюджет,
		               |	Д_БюджетПрочихПроектовЗатраты.ВНХ,
		               |	Д_БюджетПрочихПроектовЗатраты.НаЕдиницу,
		               |	Д_БюджетПрочихПроектовЗатраты.Номенклатура,
		               |	Д_БюджетПрочихПроектовЗатраты.ИнвПроект
		               |ИЗ
		               |	Документ.Д_БюджетПрочихПроектов.Затраты КАК Д_БюджетПрочихПроектовЗатраты
		               |ГДЕ
		               |	Д_БюджетПрочихПроектовЗатраты.Ссылка.Сценарий = &Сценарий
		               |	И Д_БюджетПрочихПроектовЗатраты.ЦФО = &ЦФО
		               |	И Д_БюджетПрочихПроектовЗатраты.Бюджет В(&Бюджет)
		               |	И ВЫБОР
		               |			КОГДА &ТолькоВнесенные = ИСТИНА
		               |				ТОГДА Д_БюджетПрочихПроектовЗатраты.ВнесенаВБюджет = ИСТИНА
		               |			ИНАЧЕ ИСТИНА
		               |		КОНЕЦ
		               |	И Д_БюджетПрочихПроектовЗатраты.Ссылка.ПометкаУдаления = ЛОЖЬ
		               |	И ВЫБОР
		               |			КОГДА &АктуальныйПериод ЕСТЬ NULL 
		               |				ТОГДА ИСТИНА
		               |			ИНАЧЕ Д_БюджетПрочихПроектовЗатраты.Месяц = &АктуальныйПериод
		               |		КОНЕЦ";
			
	Иначе	
		Запрос.Текст = "ВЫБРАТЬ
		               |	Д_БюджетПрочихПроектовЗатратыКП.Ссылка,
		               |	Д_БюджетПрочихПроектовЗатратыКП.НомерСтроки,
		               |	Д_БюджетПрочихПроектовЗатратыКП.СтатьяЗатрат,
		               |	Д_БюджетПрочихПроектовЗатратыКП.ЛимитНаНачало,
		               |	Д_БюджетПрочихПроектовЗатратыКП.СуммаСеб,
		               |	Д_БюджетПрочихПроектовЗатратыКП.СуммаБДДС,
		               |	Д_БюджетПрочихПроектовЗатратыКП.СтатьяБДДС,
		               |	Д_БюджетПрочихПроектовЗатратыКП.Источник,
		               |	Д_БюджетПрочихПроектовЗатратыКП.Номенклатура,
		               |	Д_БюджетПрочихПроектовЗатратыКП.Основание,
		               |	Д_БюджетПрочихПроектовЗатратыКП.ВидДеятельности КАК Подразделение,
		               |	Д_БюджетПрочихПроектовЗатратыКП.Месяц,
		               |	Д_БюджетПрочихПроектовЗатратыКП.ЦФО,
		               |	Д_БюджетПрочихПроектовЗатратыКП.ИнвПроект,
		               |	Д_БюджетПрочихПроектовЗатратыКП.ЛимитНаНачалоДДС,
		               |	Д_БюджетПрочихПроектовЗатратыКП.НаЕдиницу,
		               |	Д_БюджетПрочихПроектовЗатратыКП.УИД,
		               |	Д_БюджетПрочихПроектовЗатратыКП.Бюджет,
		               |	Д_БюджетПрочихПроектовЗатратыКП.ВНХ
		               |ИЗ
		               |	Документ.Д_БюджетПрочихПроектов.ЗатратыКП КАК Д_БюджетПрочихПроектовЗатратыКП
		               |ГДЕ
		               |	Д_БюджетПрочихПроектовЗатратыКП.Ссылка.Сценарий = &Сценарий
		               |	И Д_БюджетПрочихПроектовЗатратыКП.ЦФО = &ЦФО
		               |	И Д_БюджетПрочихПроектовЗатратыКП.Бюджет В(&Бюджет)
		               |	И ВЫБОР
		               |			КОГДА &ТолькоВнесенные = ИСТИНА
		               |				ТОГДА Д_БюджетПрочихПроектовЗатратыКП.ВнесенаВБюджет = ИСТИНА
		               |			ИНАЧЕ ИСТИНА
		               |		КОНЕЦ
		               |	И Д_БюджетПрочихПроектовЗатратыКП.Ссылка.ПометкаУдаления = ЛОЖЬ
		               |	И ВЫБОР
		               |			КОГДА &АктуальныйПериод ЕСТЬ NULL 
		               |				ТОГДА ИСТИНА
		               |			ИНАЧЕ Д_БюджетПрочихПроектовЗатратыКП.Месяц = &АктуальныйПериод
		               |		КОНЕЦ";	
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("ЦФО", Предприятие);
	Запрос.УстановитьПараметр("Бюджет", МассивБюджетов);
	Запрос.УстановитьПараметр("ТолькоВнесенные", ТолькоВнесенные);
	Запрос.УстановитьПараметр("АктуальныйПериод", ?(ЗначениеЗаполнено(АктуальныйПериод), НачалоМесяца(АктуальныйПериод), Null));
	
	Результат = Запрос.Выполнить();
	ТЗ_Рез = Результат.Выгрузить();
	
	// обновляем актуальность ТЧ по данным регистра
	Для Каждого ТекБюджет Из МассивБюджетов Цикл
		СтрокиКДобавлению = ПолучитьИзмененныеСтрокиОперативныхБюджетов(ТекБюджет, Истина);
		СтрокиКУдалению = ПолучитьИзмененныеСтрокиОперативныхБюджетов(ТекБюджет, Ложь);
		
		Для Каждого Строка Из СтрокиКДобавлению Цикл
			
			Если ТЗ_Рез.НайтиСтроки(Новый Структура("Ссылка, УИД", Строка.ОперативныйБюджет, Строка.УИДСтроки)).Количество() Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокиДобавления = ПолучитьСтрокуОперативногоБюджетаПоИдентификатору(Строка.УИДСтроки, Строка.ОперативныйБюджет, Корректировка);
			
			Если СтрокиДобавления.Количество() Тогда
				
				Если ЗначениеЗаполнено(АктуальныйПериод) И Не НачалоМесяца(АктуальныйПериод) = СтрокиДобавления[0].Месяц Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = ТЗ_Рез.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокиДобавления[0]);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого Строка Из СтрокиКУдалению Цикл
			СтрокаУдаления = ТЗ_Рез.Найти(Строка.УИДСтроки);
			
			Если ТЗ_Рез.Найти(Строка.УИДСтроки) <> Неопределено Тогда
				ТЗ_Рез.Удалить(СтрокаУдаления);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТЗ_Рез;
	
КонецФункции

Функция ЭтоКорректировочныйБюджет(Сценарий) Экспорт
	Если КонецМесяца(Сценарий.АктуальнаяДата) = КонецМесяца(Сценарий.ДатаКонца) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;	
	КонецЕсли;	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуИзОперативногоБюджета(Бюджет, ОперативныйБюджет, УИД, Внесена) Экспорт
	
	// регистр строки оперативного бюджета
	НаборЗаписей = РегистрыСведений.Б_СтрокиОперативныхБюджетов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Бюджет.Установить(Бюджет);
	НаборЗаписей.Отбор.ОперативныйБюджет.Установить(ОперативныйБюджет);
	НаборЗаписей.Отбор.УИДСтроки.Установить(УИД);
	НаборЗаписей.Прочитать();
	Если НЕ НаборЗаписей.Количество() Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Бюджет = Бюджет;
		НоваяЗапись.ОперативныйБюджет = ОперативныйБюджет;
		НоваяЗапись.УИДСтроки = УИД;
		НоваяЗапись.ВнесенаВБюджет = Внесена;	
	Иначе
		ТекущаяЗапись = НаборЗаписей[0];
		ТекущаяЗапись.ВнесенаВБюджет = Внесена;
	КонецЕсли;
	НаборЗаписей.Записать();
	//
		
КонецПроцедуры

&НаСервере
Функция ПолучитьИзмененныеСтрокиОперативногоБюджета(Документ, Внести) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДок", Документ);
	ЗАпрос.УстановитьПараметр("Внесена", Внести);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Б_СтрокиОперативныхБюджетов.УИДСтроки,
	               |	Б_СтрокиОперативныхБюджетов.Бюджет
	               |ИЗ
	               |	РегистрСведений.Б_СтрокиОперативныхБюджетов КАК Б_СтрокиОперативныхБюджетов
	               |ГДЕ
	               |	Б_СтрокиОперативныхБюджетов.ОперативныйБюджет = &ТекущийДок
	               |	И Б_СтрокиОперативныхБюджетов.ВнесенаВБюджет = &Внесена";
	Результат = Запрос.Выполнить();
	ТЗ_Рез = Результат.Выгрузить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТЗ_Рез;
	
КонецФункции

&НаСервере
Функция ПолучитьИзмененныеСтрокиОперативныхБюджетов(Документ, Внести) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДок", Документ);
	ЗАпрос.УстановитьПараметр("Внесена", Внести);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Б_СтрокиОперативныхБюджетов.УИДСтроки,
	               |	Б_СтрокиОперативныхБюджетов.ОперативныйБюджет
	               |ИЗ
	               |	РегистрСведений.Б_СтрокиОперативныхБюджетов КАК Б_СтрокиОперативныхБюджетов
	               |ГДЕ
	               |	Б_СтрокиОперативныхБюджетов.Бюджет = &ТекущийДок
	               |	И Б_СтрокиОперативныхБюджетов.ВнесенаВБюджет = &Внесена";
	Результат = Запрос.Выполнить();  
	ТЗ_Рез = Результат.Выгрузить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТЗ_Рез;
	
КонецФункции

&НаСервере
Процедура ОчиститьНаборЗаписейПоУникальномуИдентификатору(Бюджет, ОперативныйБюджет, УИД) Экспорт
	
	НаборЗаписей = РегистрыСведений.Б_СтрокиОперативныхБюджетов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Бюджет.Установить(Бюджет);
	НаборЗаписей.Отбор.ОперативныйБюджет.Установить(ОперативныйБюджет);
	НаборЗаписей.Отбор.УИДСтроки.Установить(УИД);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() Тогда
    	НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуОперативногоБюджетаПоИдентификатору(УИД, ОперативныйБюджет, КорректировочныйБюджет) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	ЗАпрос.УстановитьПараметр("УИД", УИД);
	Запрос.УстановитьПараметр("Док", ОперативныйБюджет);
	Если КорректировочныйБюджет Тогда
		ЗАпрос.Текст = "ВЫБРАТЬ
		|	Д_БюджетПрочихПроектовЗатратыКП.Ссылка,
		|	Д_БюджетПрочихПроектовЗатратыКП.НомерСтроки,
		|	Д_БюджетПрочихПроектовЗатратыКП.СтатьяЗатрат,
		|	Д_БюджетПрочихПроектовЗатратыКП.ЛимитНаНачало,
		|	Д_БюджетПрочихПроектовЗатратыКП.СуммаСеб,
		|	Д_БюджетПрочихПроектовЗатратыКП.СуммаБДДС,
		|	Д_БюджетПрочихПроектовЗатратыКП.СтатьяБДДС,
		|	Д_БюджетПрочихПроектовЗатратыКП.Источник,
		|	Д_БюджетПрочихПроектовЗатратыКП.Номенклатура,
		|	Д_БюджетПрочихПроектовЗатратыКП.Основание,
		|	Д_БюджетПрочихПроектовЗатратыКП.ВидДеятельности КАК Подразделение,
		|	Д_БюджетПрочихПроектовЗатратыКП.Месяц,
		|	Д_БюджетПрочихПроектовЗатратыКП.ЦФО,
		|	Д_БюджетПрочихПроектовЗатратыКП.ИнвПроект,
		|	Д_БюджетПрочихПроектовЗатратыКП.ЛимитНаНачалоДДС,
		|	Д_БюджетПрочихПроектовЗатратыКП.НаЕдиницу,
		|	Д_БюджетПрочихПроектовЗатратыКП.УИД,
		|	Д_БюджетПрочихПроектовЗатратыКП.Бюджет,
		|	Д_БюджетПрочихПроектовЗатратыКП.ВнесенаВБюджет,
		|	Д_БюджетПрочихПроектовЗатратыКП.ВНХ
		|ИЗ
		|	Документ.Д_БюджетПрочихПроектов.ЗатратыКП КАК Д_БюджетПрочихПроектовЗатратыКП
		|ГДЕ
		|	Д_БюджетПрочихПроектовЗатратыКП.Ссылка = &Док
		|	И Д_БюджетПрочихПроектовЗатратыКП.УИД = &УИД";
		
	Иначе
		ЗАпрос.Текст = "ВЫБРАТЬ
		|	Д_БюджетПрочихПроектовЗатраты.Ссылка,
		|	Д_БюджетПрочихПроектовЗатраты.НомерСтроки,
		|	Д_БюджетПрочихПроектовЗатраты.Признак,
		|	Д_БюджетПрочихПроектовЗатраты.СтатьяЗатрат,
		|	Д_БюджетПрочихПроектовЗатраты.СуммаСеб,
		|	Д_БюджетПрочихПроектовЗатраты.СуммаБДДС,
		|	Д_БюджетПрочихПроектовЗатраты.СтатьяБДДС,
		|	Д_БюджетПрочихПроектовЗатраты.Источник,
		|	Д_БюджетПрочихПроектовЗатраты.Подразделение,
		|	Д_БюджетПрочихПроектовЗатраты.Основание,
		|	Д_БюджетПрочихПроектовЗатраты.ЦФО,
		|	Д_БюджетПрочихПроектовЗатраты.Месяц,
		|	Д_БюджетПрочихПроектовЗатраты.УИД,
		|	Д_БюджетПрочихПроектовЗатраты.Бюджет,
		|	Д_БюджетПрочихПроектовЗатраты.БизнесПроцесс,
		|	Д_БюджетПрочихПроектовЗатраты.Номенклатура,
		|	Д_БюджетПрочихПроектовЗатраты.НаЕдиницу,
		|	Д_БюджетПрочихПроектовЗатраты.ВнесенаВБюджет,
		|	Д_БюджетПрочихПроектовЗатраты.ВНХ
		|ИЗ
		|	Документ.Д_БюджетПрочихПроектов.Затраты КАК Д_БюджетПрочихПроектовЗатраты
		|ГДЕ
		|	Д_БюджетПрочихПроектовЗатраты.Ссылка = &Док
		|	И Д_БюджетПрочихПроектовЗатраты.УИД = &УИД";
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	ТЗ_Рез = Результат.Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Возврат ТЗ_Рез;
	
КонецФункции

// Функция - Получить сценарий для оперативных бюджетов
//
// Параметры:
//  ИсходныйСценарий - сценарий плана текущего документа
// Возвращаемое значение:
//   СценарийОБ - сценарий, по которому получаем данные из оперативных бюджетов. Сцеанрий документа, либо сценарий первоначальный в зависимости от того, является ли сценарий документа корректировочным. 
&НаСервере
Функция ПолучитьСценарийДляОперативныхБюджетов(ИсходныйСценарий) Экспорт
	
	Если ИсходныйСценарий.ВидБюджета = Перечисления.Д_ВидыБюджета.МесячныйБюджет И ЗначениеЗаполнено(ИсходныйСценарий.Родитель) Тогда
		СценарийОБ = ИсходныйСценарий.Родитель
	Иначе
		СценарийОБ = ИсходныйСценарий
	КонецЕсли;
	
	Возврат СценарийОБ;
	
КонецФункции

// Функция - Бюджеты по сценарию и предприятияю
//
// Параметры:
//  Сценарий	 - 	 - 
//  Предприятие	 - 	 - 
// Возвращаемое значение:
//  МассивБюджетов - массив из документов "Бюджет" полученных по передаваемым параметрам.
&НаСервере
Функция БюджетыПоСценариюИПредприятияю(Сценарий, Предприятие)
	
	МассивБюджетов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Д_Бюджет.Ссылка
	               |ИЗ
	               |	Документ.Д_Бюджет КАК Д_Бюджет
	               |ГДЕ
	               |	Д_Бюджет.ПометкаУдаления = ЛОЖЬ
	               |	И Д_Бюджет.Сценарий = &Сценарий
	               |	И Д_Бюджет.Предприятие = &Предприятие";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивБюджетов.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат МассивБюджетов;
	
КонецФункции

// Функция - Проверить уникальность бюджета
//
// Параметры:
//  Сценарий	 -  сценарий, по которому создается документ 
//  Предприятие	 -  предприятие, по которому создается документ
// Возвращаемое значение:
//   - Истина если бюджет с такими параметрами еще не создан, Ложь в противном случае.
&НаСервере
Функция ПроверитьУникальностьБюджета(Сценарий, Предприятие) Экспорт
	
	МассивБюджетов = БюджетыПоСценариюИПредприятияю(Сценарий, Предприятие);
	Возврат МассивБюджетов.Количество();
	
КонецФункции

// Функция - Получить бюджетный документ по сценарию и предприятию. Возвращает массив (как правило состоящий из одного элемента из-за уникальности бюджета по предприятию и сценарию) бюджетных документов.
//
// Параметры:
//  Сценарий	 - 	 - 
//  Предприятие	 - 	 - 
// Возвращаемое значение:
//  МассивБюджетов - Массив.  
&НаСервере
Функция ПолучитьБюджетныйДокументПоСценариюИПредприятию(Сценарий, Предприятие) Экспорт
	
 Возврат БюджетыПоСценариюИПредприятияю(Сценарий, Предприятие);
	
КонецФункции

// Функция - Поиск б.п. утверждение бюджета
//
// Параметры:
//  Ссылка		 -  документ "Бюджет", для которого ищем запущенный бизнес-процесс
//  ТипБюджета	 - 	тип бизнес-процесса "Утверждение бюджета" 
// Возвращаемое значение:
//   - ссылка на запущенный БП, либо неопределено
&НаСервере
Функция ПоискБП_УтверждениеБюджета(Ссылка, ТипБюджета = Неопределено) Экспорт
	//ищем созданные бизнес-процессы
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	УтверждениеБюджета.Ссылка КАК Ссылка,
	//               |	УтверждениеБюджета.ТипБюджета КАК ТипБюджета
	//               |ИЗ
	//               |	БизнесПроцесс.УтверждениеБюджета КАК УтверждениеБюджета
	//               |ГДЕ
	//               |	УтверждениеБюджета.Заявка = &Заявка
	//               |	И ВЫБОР
	//               |			КОГДА &ТипБюджета = НЕОПРЕДЕЛЕНО
	//               |				ТОГДА ИСТИНА
	//               |			ИНАЧЕ УтверждениеБюджета.ТипБюджета = &ТипБюджета
	//               |		КОНЕЦ
	//               |	И УтверждениеБюджета.ПометкаУдаления = ЛОЖЬ";
	//
	//Запрос.УстановитьПараметр("Заявка", Ссылка);
	//Запрос.УстановитьПараметр("ТипБюджета", ?(ТипБюджета = Неопределено, Неопределено, Перечисления.Д_ТипыБюджетов[ТипБюджета]));
	//
	//Результат = Запрос.Выполнить();
	//Выборка = Результат.Выгрузить();
	//Если Выборка.Количество() Тогда
	//	
	//	СписокБП = Выборка.ВыгрузитьКолонку("Ссылка");
	//	
	//	ЗапросЗадачи = Новый Запрос;
	//	ЗапросЗадачи.Текст = "ВЫБРАТЬ
	//	                     |	Задача.Ссылка КАК Ссылка,
	//	                     |	Задача.БизнесПроцесс КАК БизнесПроцесс
	//	                     |ИЗ
	//	                     |	Задача.Задача КАК Задача
	//	                     |ГДЕ
	//	                     |	Задача.БизнесПроцесс В(&БизнесПроцесс)
	//	                     |	И Задача.ТочкаМаршрута = &ТочкаМаршрута
	//	                     |	И Задача.Выполнена = ЛОЖЬ
	//	                     |	И Задача.ПометкаУдаления = ЛОЖЬ";
	//	ЗапросЗадачи.УстановитьПараметр("БизнесПроцесс", СписокБП);
	//	ЗапросЗадачи.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.УтверждениеБюджета.ТочкиМаршрута.Действие1);
	//	РезультатЗадачи = ЗапросЗадачи.Выполнить();
	//	ВыборкаЗадачи = РезультатЗадачи.Выбрать();
	//	Если ВыборкаЗадачи.Следующий() Тогда
	//		Возврат Неопределено
	//	Иначе
	//		Возврат Выборка.Ссылка;
	//	КонецЕсли;
	//Иначе
		Возврат Неопределено;	
	//КонецЕсли;
	
КонецФункции 

Функция СтатьяИнв(ТекСтатья) Экспорт

	ЭтоИнвСтатья = Ложь;
	
	//Если ТипЗнч(ТекСтатья) = Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств") Тогда
	//	ЭтоИнвСтатья = (ТекСтатья.ВидДеятельности = Перечисления.саб_Фин_ВидыДеятельности.ИД)
	//ИначеЕсли ТипЗнч(ТекСтатья) = Тип("СправочникСсылка.СтатьиЗатрат") Тогда
	//	
	//	Если ЗначениеЗаполнено(ТекСтатья.СтатьяБДДС) Тогда
	//		ЭтоИнвСтатья = (ТекСтатья.СтатьяБДДС.ВидДеятельности = Перечисления.саб_Фин_ВидыДеятельности.ИД)
	//	КонецЕсли;
	//	
	//ИначеЕсли ТипЗнч(ТекСтатья) = Тип("СправочникСсылка.СтатьиДоходовРасходов") Тогда
	//	ЭтоИнвСтатья = (ТекСтатья = Справочники.СтатьиДоходовРасходов.Инвестиции)
	//КонецЕсли;
		
	Возврат ЭтоИнвСтатья;
	
КонецФункции

Функция СтатьяПредставительскихРасходов(ТекСтатья) Экспорт
	
	УчетнаяПолитикаПерем = Справочники.УчетныеПолитики.НайтиПоНаименованию("Общая", Истина); //по хорошему надо брать из предприятия
	Возврат НЕ УчетнаяПолитикаПерем.СтатьиДДСПредставительские.Найти(ТекСтатья, "СтатьяДДС") = Неопределено;
	
КонецФункции

&НаСервере
// функция возвращает должность пользователя на данном предприятии
Функция ВернутьДолжностьПользователяНаПредприятии(Пользователь, Предприятие) Экспорт
	
	ДолжностьПользователяНаПредприятии = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОсновныеДолжностиПредприятия.Должность
	               |ИЗ
	               |	РегистрСведений.ОсновныеДолжностиПредприятия КАК ОсновныеДолжностиПредприятия
	               |ГДЕ
	               |	ОсновныеДолжностиПредприятия.Предприятие = &Предприятие
	               |	И ОсновныеДолжностиПредприятия.Сотрудник = &Пользователь";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДолжностьПользователяНаПредприятии = Выборка.Должность;
	КонецЦикла;
	
	Возврат ДолжностьПользователяНаПредприятии;
	
КонецФункции

Функция ПолучитьПлановыйКурс(Сценарий, Валюта1, Валюта2, ДатаПолучения = Неопределено) Экспорт
	
	СтруктураВозврата = Новый Структура;
    СтруктураВозврата.Вставить("КурсНайден", Ложь);
	
	Курс = 1;
	
	Если Не ЗначениеЗаполнено(ДатаПолучения) Тогда
		ДатаПолучения = ТекущаяДата();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сценарий) Тогда
		ТекСценарий = БюджетныйНаСервере.ПолучитьАктуальныйСценарий(ДатаПолучения, Истина);	
	Иначе
		ТекСценарий = Сценарий;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекСценарий) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Б_ПлановыеКурсыВалютСрезПоследних.Курс
		|ИЗ
		|	РегистрСведений.Б_ПлановыеКурсыВалют.СрезПоследних(
		|			&ТекДата,
		|			Сценарий В (&Сценарий)
		|				И Валюта1 = &Валюта1
		|				И Валюта2 = &Валюта2) КАК Б_ПлановыеКурсыВалютСрезПоследних";
		
		Запрос.УстановитьПараметр("ТекДата", ТекСценарий.АктуальнаяДата);
		Запрос.УстановитьПараметр("Сценарий", ТекСценарий);
		Запрос.УстановитьПараметр("Валюта1", Валюта1);
		Запрос.УстановитьПараметр("Валюта2", Валюта2);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Количество() Тогда
			СтруктураВозврата.КурсНайден = Истина;
		КонецЕсли;
		
		Пока Выборка.Следующий() Цикл	
			Курс = Выборка.Курс;	
		КонецЦикла;
		
		Если Не СтруктураВозврата.КурсНайден Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	Б_ПлановыеКурсыВалютСрезПоследних.Курс
			|ИЗ
			|	РегистрСведений.Б_ПлановыеКурсыВалют.СрезПоследних(
			|			&ТекДата,
			|			Сценарий В (&Сценарий)
			|				И Валюта1 = &Валюта1
			|				И Валюта2 = &Валюта2) КАК Б_ПлановыеКурсыВалютСрезПоследних";
			
			Запрос.УстановитьПараметр("ТекДата", ТекСценарий.АктуальнаяДата);
			Запрос.УстановитьПараметр("Сценарий", ТекСценарий);
			Запрос.УстановитьПараметр("Валюта1", Валюта2);
			Запрос.УстановитьПараметр("Валюта2", Валюта1);
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
						
			Пока Выборка.Следующий() Цикл
				
				Если Не Выборка.Курс = 0 Тогда
					СтруктураВозврата.КурсНайден = Истина;
					Курс = Окр(1/Выборка.Курс, 5);	
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураВозврата.Вставить("Курс", Курс);
	СтруктураВозврата.Вставить("Сценарий", ТекСценарий);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Функция ПолучитьТипБюджетаСтрокиКорректировок(ИП) Экспорт
	
	Если ТипЗнч(ИП) = Тип("СправочникСсылка.ОбъектыСтроительства") Тогда
		ТипБюджета = Перечисления.Д_ТипыБюджетов.КорректировкиИнвестиций;
	ИначеЕсли ТипЗнч(ИП) = Тип("СправочникСсылка.ПредставительскиеРасходы") Тогда
		ТипБюджета = Перечисления.Д_ТипыБюджетов.КорректировкиПредставительскихРасходов;
	Иначе 
		ТипБюджета = Перечисления.Д_ТипыБюджетов.КорректировкиБюджета;
	КонецЕсли;
	
	Возврат ТипБюджета;
	
КонецФункции

// Функция - ПБ_СценарийУтвержден. Сценарий утвержден, если утверждены все созданные по нему бюджеты
//
// Параметры:
//  Сценарий		 -  проверяемый сценарий планирования
// Возвращаемое значение:
//   - булево Истина, если утвержден, ложь в противном случае
&НаСервере
Функция ПБ_СценарийУтвержден(Сценарий) Экспорт
	
	ЗапросПредприятий = Новый Запрос;
	ЗапросПредприятий.УстановитьПараметр("Сценарий", Сценарий);
	ЗапросПредприятий.Текст = "ВЫБРАТЬ
	               |	Д_Бюджет.Предприятие
	               |ИЗ
	               |	Документ.Д_Бюджет КАК Д_Бюджет
	               |ГДЕ
	               |	Д_Бюджет.Сценарий = &Сценарий
	               |	И Д_Бюджет.ПометкаУдаления = ЛОЖЬ";
	Результат = ЗапросПредприятий.Выполнить();
	ВыборкаПредпр = Результат.Выбрать();
	МассивПредприятий = Новый Массив;
	
	Пока ВыборкаПредпр.Следующий() Цикл
		МассивПредприятий.Добавить(ВыборкаПредпр.Предприятие);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("Предприятия", МассивПредприятий);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Б_ПараметрыБюджета.Предприятие,
	               |	Б_ПараметрыБюджета.Сценарий,
	               |	Б_ПараметрыБюджета.Утвержден
	               |ИЗ
	               |	РегистрСведений.Б_ПараметрыБюджета КАК Б_ПараметрыБюджета
	               |ГДЕ
	               |	Б_ПараметрыБюджета.Сценарий = &Сценарий
	               |	И Б_ПараметрыБюджета.Предприятие В(&Предприятия)";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Утвержден = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		Если Не Выборка.Утвержден Тогда
			Утвержден = Ложь;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Утвержден
	
КонецФункции

Функция ПолучитьСуммуВВалютеПроекта(ВалютаИсходная, ВалютаПроекта, СуммаВИсходнойВалюте, ДатаПолучения) Экспорт
	
	СуммаВВалютеПроекта = 0;
	
	Если Не ВалютаПроекта = ВалютаИсходная Тогда
		
		Если ВалютаПроекта = УЧ_Сервер.НациональнаяВалюта() Тогда
			КурсВал = ПолучитьПлановыйКурс(, ВалютаИсходная, УЧ_Сервер.НациональнаяВалюта(), ДатаПолучения).Курс; 
			СуммаВВалютеПроекта = СуммаВИсходнойВалюте * КурсВал;
		ИначеЕсли ВалютаИсходная = УЧ_Сервер.НациональнаяВалюта() Тогда
			КурсВал = ПолучитьПлановыйКурс(, ВалютаПроекта, УЧ_Сервер.НациональнаяВалюта(), ДатаПолучения).Курс; 
			
			Если Не КурсВал = 0 Тогда
				СуммаВВалютеПроекта = СуммаВИсходнойВалюте / КурсВал;
			КонецЕсли;
			
		Иначе
			КурсВал = ПолучитьПлановыйКурс(, ВалютаИсходная, ВалютаПроекта, ДатаПолучения).Курс;
			СуммаВВалютеПроекта = СуммаВИсходнойВалюте * КурсВал;
		КонецЕсли;
		
	Иначе
		СуммаВВалютеПроекта = СуммаВИсходнойВалюте;
	КонецЕсли;
	
	Возврат СуммаВВалютеПроекта;
	
КонецФункции
