
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дата = ТекущаяДата();
	Элементы.КОплатеСегодня.Заголовок = "К оплате " + ?(НачалоДня(Дата) = НачалоДня(ТекущаяДата()), "сегодня", Формат(Дата, "ДФ=dd.MM.yyyy"));
	Элементы.СписокПоступленийКОплатеСегодня.Заголовок = Элементы.КОплатеСегодня.Заголовок;
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "ПоступлениеТоваровУслуг.Товары", "Д_ЗаявкаНаФинансирование.ТабличнаяЧасть"); 
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "ПоступлениеТоваровУслугТовары.Номенклатура", "ПоступлениеТоваровУслугТовары.Документ");
	
	СписокПоступлений.ТекстЗапроса = СтрЗаменить(СписокПоступлений.ТекстЗапроса, "ПоступлениеТоваровУслуг.Товары", "Д_ЗаявкаНаФинансирование.ТабличнаяЧасть"); 
	СписокПоступлений.ТекстЗапроса = СтрЗаменить(СписокПоступлений.ТекстЗапроса, "ПоступлениеТоваровУслугТовары.Номенклатура", "ПоступлениеТоваровУслугТовары.Документ");

	//Список.Параметры.УстановитьЗначениеПараметра("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	Счета = Новый Массив;
	Счета.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.01"));
	Счета.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("76.05"));
	Список.Параметры.УстановитьЗначениеПараметра("Счета60", Счета);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(Дата));
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоДоговорыСоСрокамиОплаты", ТолькоДоговорыСоСрокамиОплаты);
	
	СписокПоступлений.Параметры.УстановитьЗначениеПараметра("Ссылка", Неопределено);
	//СписокПоступлений.Параметры.УстановитьЗначениеПараметра("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	СписокПоступлений.Параметры.УстановитьЗначениеПараметра("Счета60", Счета);
	СписокПоступлений.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(Дата));
	СписокПоступлений.Параметры.УстановитьЗначениеПараметра("ТолькоДоговорыСоСрокамиОплаты", ТолькоДоговорыСоСрокамиОплаты);
	
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		СписокПоступлений.Параметры.УстановитьЗначениеПараметра("Ссылка", Элементы.Список.ТекущаяСтрока);
	Иначе	
    	СписокПоступлений.Параметры.УстановитьЗначениеПараметра("Ссылка", Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаНаОплату(Команда)
	ТекФормаБП = ПолучитьФорму("Документ.Д_ЗаявкаНаФинансирование.ФормаОбъекта");
	ДанныеФормы = ТекФормаБП.Объект;
	ЗаполнитьНаСервере(ДанныеФормы, Элементы.Список.ТекущаяСтрока);
	КопироватьДанныеФормы(ДанныеФормы, ТекФормаБП.Объект);
	ТекФормаБП.ПриСозданииНаСервере(Ложь, Истина);
	ЗаполнитьНаСервере(ДанныеФормы, Элементы.Список.ТекущаяСтрока);
	КопироватьДанныеФормы(ДанныеФормы, ТекФормаБП.Объект);
	ТекФормаБП.СформироватьНазначениеПлатежа(Истина);
	ТекФормаБП.Открыть();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере(ДанныеФормы, Договор)
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДоговорыКонтрагентов.Ссылка КАК Договор,
	               |	ДоговорыКонтрагентов.Владелец КАК Владелец,
	               |	ДоговорыКонтрагентов.СрокДействия КАК СрокДействия,
	               |	ДоговорыКонтрагентов.СрокОплаты КАК СрокОплаты,
	               |	-ХозрасчетныйОстатки.СуммаОстаток КАК СуммаОстаток,
	               |	ВЫБОР
	               |		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ПоступлениеТоваровУслуг).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) < &ТекущаяДата
	               |			ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ + ВЫБОР
	               |		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ДокументРасчетовСКонтрагентом).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) < &ТекущаяДата
	               |			ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК Просрочено,
	               |	ВЫБОР
	               |		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ПоступлениеТоваровУслуг).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) >= &ТекущаяДата
	               |			ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ + ВЫБОР
	               |		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ДокументРасчетовСКонтрагентом).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) >= &ТекущаяДата
	               |			ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК Нормально,
	               |	ВЫБОР
	               |		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ПоступлениеТоваровУслуг).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) <= &ТекущаяДата
	               |			ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ + ВЫБОР
	               |		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ДокументРасчетовСКонтрагентом).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) <= &ТекущаяДата
	               |			ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК КОплатеСегодня,
	               |	ЕСТЬNULL(ПоступлениеТоваровУслугТовары.Сумма, 0) КАК Заявлено,
	               |	ХозрасчетныйОстатки.Субконто3 КАК Документ,
	               |	ХозрасчетныйОстатки.Организация КАК Организация,
	               |	ХозрасчетныйОстатки.Подразделение КАК Подразделение
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(, Счет В ИЕРАРХИИ (&Счета60), , ) КАК ХозрасчетныйОстатки
	               |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
	               |			ПО ХозрасчетныйОстатки.Субконто3 = ПоступлениеТоваровУслугТовары.Номенклатура
	               |				И (НЕ ПоступлениеТоваровУслугТовары.Номенклатура.ПометкаУдаления)
	               |		ПО ДоговорыКонтрагентов.Ссылка = ХозрасчетныйОстатки.Субконто2
	               |ГДЕ
	               |	(НЕ &ТолькоДоговорыСоСрокамиОплаты
	               |			ИЛИ ДоговорыКонтрагентов.УстановленСрокОплаты = &ТолькоДоговорыСоСрокамиОплаты)
	               |	И ДоговорыКонтрагентов.Ссылка = &Ссылка
	               |	И ВЫБОР
	               |			КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ПоступлениеТоваровУслуг).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) <= &ТекущаяДата
	               |				ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |			ИНАЧЕ 0
	               |		КОНЕЦ + ВЫБОР
	               |			КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто3 КАК Документ.ДокументРасчетовСКонтрагентом).Дата, ДЕНЬ, ДоговорыКонтрагентов.СрокОплаты), ДЕНЬ) <= &ТекущаяДата
	               |				ТОГДА -ХозрасчетныйОстатки.СуммаОстаток
	               |			ИНАЧЕ 0
	               |		КОНЕЦ - ЕСТЬNULL(ПоступлениеТоваровУслугТовары.Сумма, 0) > 0";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПоступлениеТоваровУслуг.Товары", "Д_ЗаявкаНаФинансирование.ТабличнаяЧасть"); 
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПоступлениеТоваровУслугТовары.Номенклатура", "ПоступлениеТоваровУслугТовары.Документ");
	
	Запрос.УстановитьПараметр("Ссылка", Договор);
	//Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	
	Счета = Новый Массив;
	Счета.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.01"));
	Счета.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("76.05"));

	Запрос.УстановитьПараметр("Счета60", Счета);
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(Дата));
	Запрос.УстановитьПараметр("ТолькоДоговорыСоСрокамиОплаты", ТолькоДоговорыСоСрокамиОплаты);
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	ДанныеФормы.СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Оплата поставщикам (подрядчикам)", Истина);
	
	ДанныеФормы.ТабличнаяЧасть.Очистить();
	
	Пока Выборка.Следующий() Цикл
		ДанныеФормы.Организация = Выборка.Организация;
		ДанныеФормы.БанковскийСчет = Выборка.Организация.ОсновнойБанковскийСчет;
		НоваяСтрока = ДанныеФормы.ТабличнаяЧасть.Добавить();
		НоваяСтрока.Предприятие = Выборка.Организация.Предприятие;
		НоваяСтрока.СтатьяДДС = ДанныеФормы.СтатьяДДС;
		НоваяСтрока.Документ = Выборка.Документ;
		НоваяСтрока.УИДСтроки = Новый УникальныйИдентификатор;
		//НоваяСтрока.Сумма = Выборка.СуммаОстаток;
		ДанныеФормы.Контрагент = Выборка.Договор.Владелец;
		ДанныеФормы.Договор = Выборка.Договор;
		ДанныеФормы.СчетКонтрагента = Выборка.Договор.Владелец.ОсновнойБанковскийСчет;
		
		Если ТипЗнч(Выборка.Документ) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
			Для каждого ТекСтрока Из Выборка.Документ.Товары Цикл
				НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаНДС + ТекСтрока.СуммаНДС;
				НоваяСтрока.СтавкаНДС = ?(НоваяСтрока.СуммаНДС, сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСБУХУУ().Получить(ТекСтрока.СтавкаНДС), Справочники.СтавкиНДС.НАйтиПоНаименованию("Без НДС", Истина));
				НоваяСтрока.Сумма = НоваяСтрока.Сумма + ?(Выборка.Документ.СуммаВключаетНДС, ТекСтрока.Сумма, ТекСтрока.Сумма + ТекСтрока.СуммаНДС);
			КонецЦикла;
		ИначеЕсли ТипЗнч(Выборка.Документ) = Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом") Тогда
			НоваяСтрока.Сумма = Выборка.КОплатеСегодня;
			НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.НАйтиПоНаименованию("Без НДС", Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	ДанныеФормы.Предприятие = ДанныеФормы.Организация.Предприятие;
	ДанныеФормы.ЦФО = ДанныеФормы.Предприятие;
	ДанныеФормы.Сумма = ДанныеФормы.ТабличнаяЧасть.Итог("Сумма");
	ДанныеФормы.СуммаНДС = ДанныеФормы.ТабличнаяЧасть.Итог("СуммаНДС");
	Если ДанныеФормы.ТабличнаяЧасть.Количество() Тогда
		ДанныеФормы.СтавкаНДС = ?(НоваяСтрока.СуммаНДС, НоваяСтрока.СтавкаНДС, Справочники.СтавкиНДС.НАйтиПоНаименованию("Без НДС", Истина));
	Иначе	
		ДанныеФормы.СтавкаНДС = Справочники.СтавкиНДС.НАйтиПоНаименованию("Без НДС", Истина);
	КонецЕсли;
	ДанныеФормы.РасшифровкаПлатежа = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоги()
	
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных();
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
	
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ИтогоОстаток = Результат.Итог("СуммаОстаток");
	ИтогоПросрочено = Результат.Итог("Просрочено");
	ИтогоНормально = Результат.Итог("Нормально");
	ИтогоКОплате = Результат.Итог("КОплатеСегодня");
	ИтогоКОплатеЗавтра = Результат.Итог("КОплатеЗавтра");
	ИтогоКОплатеПослезавтра = Результат.Итог("КОплатеПослезавтра");
	ИтогоЗаявлено = Результат.Итог("Заявлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "сабОбноватьПлатежныйКалендарь" Тогда
		Элементы.Список.Обновить();
		Элементы.СписокПоступлений.Обновить();
		ОбновитьИтоги();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	Список.Отбор.Элементы.Очистить();
	Если ЗначениеЗаполнено(Контрагент) Тогда
		НовыйОтбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение = Контрагент;
	Иначе
		
		//Для каждого ТекОтбор Из Список.Отбор.Элементы Цикл
		//	Если ТипЗнч(ТекОтбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		//		Если Строка(ТекОтбор.ЛевоеЗначение) = "Владелец" Тогда
		//			ТекОтбор.Использование = Ложь;				
		//		КонецЕсли;
		//	КонецЕсли;
		//КонецЦикла;		
	КонецЕсли;
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Элементы.КОплатеСегодня.Заголовок = "К оплате " + ?(НачалоДня(Дата) = НачалоДня(ТекущаяДата()), "сегодня", Формат(Дата, "ДФ=dd.MM.yyyy"));
	Элементы.СписокПоступленийКОплатеСегодня.Заголовок = Элементы.КОплатеСегодня.Заголовок;
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(Дата));
	СписокПоступлений.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(Дата));
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	Элементы.Список.Обновить();
	Элементы.СписокПоступлений.Обновить();
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ТолькоДоговорыСоСрокамиОплатыПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоДоговорыСоСрокамиОплаты", ТолькоДоговорыСоСрокамиОплаты);
	СписокПоступлений.Параметры.УстановитьЗначениеПараметра("ТолькоДоговорыСоСрокамиОплаты", ТолькоДоговорыСоСрокамиОплаты);
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура СписокПоступленийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекДанные = Элементы.СписокПоступлений.ДанныеСтроки(Элементы.СписокПоступлений.ТекущаяСтрока);
	ПоказатьЗначение(, ТекДанные.Документ);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры
