﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	ФормироватьУПД = Истина;
	СоздаватьСчетНаОплатуПокупателю = Истина;
	ПроводитьДокументы = Истина;
	ЗаполнитьЗначенияСтрок();
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	ПредприятиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере()
	сабОбщегоНазначенияКлиентСервер.СкрытьПодразделения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Пересчитать", Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказКлиента.Ссылка КАК ЗаказКлиента,
	               |	ЕСТЬNULL(ПередачаТоваров.Ссылка, ЕСТЬNULL(РеализацияТоваровУслуг.Ссылка, ЕСТЬNULL(РозничнаяПродажа.Ссылка, УЧ_Реализация.Ссылка))) КАК Реализация
	               |ИЗ
	               |	Документ.ЗаказКлиента КАК ЗаказКлиента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РозничнаяПродажа КАК РозничнаяПродажа
	               |		ПО ЗаказКлиента.Ссылка = РозничнаяПродажа.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |		ПО ЗаказКлиента.Ссылка = РеализацияТоваровУслуг.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УЧ_Реализация КАК УЧ_Реализация
	               |		ПО ЗаказКлиента.Ссылка = УЧ_Реализация.ДокОснование
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПередачаТоваров КАК ПередачаТоваров
	               |		ПО ЗаказКлиента.Ссылка = ПередачаТоваров.Заказ
	               |ГДЕ
	               |	ЗаказКлиента.Ссылка В(&ЗаказКлиента)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЗаказНаВозвратОтКлиента.Ссылка,
	               |	ЕСТЬNULL(ОприходованиеТоваров.Ссылка, ЕСТЬNULL(ВозвратТоваровОтПокупателя.Ссылка, ЕСТЬNULL(РозничнаяПродажа.Ссылка, УЧ_Возврат.Ссылка)))
	               |ИЗ
	               |	Документ.ЗаказНаВозвратОтКлиента КАК ЗаказНаВозвратОтКлиента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РозничнаяПродажа КАК РозничнаяПродажа
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = РозничнаяПродажа.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = ВозвратТоваровОтПокупателя.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УЧ_Возврат КАК УЧ_Возврат
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = УЧ_Возврат.ДокОснование
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОприходованиеТоваров КАК ОприходованиеТоваров
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = ОприходованиеТоваров.Заказ
	               |ГДЕ
	               |	ЗаказНаВозвратОтКлиента.Ссылка В(&ЗаказКлиента)";
	
	Запрос.УстановитьПараметр("ЗаказКлиента", Объект.ТабличнаяЧасть.Выгрузить().ВыгрузитьКолонку("ЗаказКлиента"));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НайденныеСтроки = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("ЗаказКлиента", Выборка.ЗаказКлиента));
		Для Каждого ТекСтрока Из НайденныеСтроки Цикл
			Если Не ЗначениеЗаполнено(ТекСтрока.Реализация) И ЗначениеЗаполнено(Выборка.Реализация) Тогда
				ТекСтрока.Реализация = Выборка.Реализация;
				ЕстьНеобновленныеРеализации = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма, ТекущийОбъект);
	
	СтатусОтгружен = Перечисления.СтатусыЗаказовКлиентов.Отгружен;
	
	Для каждого ТекСтрока Из Объект.ТабличнаяЧасть Цикл
		Если НЕ ТекСтрока.ЗаказКлиента.Статус = СтатусОтгружен Тогда
			ТекЗаказ = ТекСтрока.ЗаказКлиента.ПолучитьОбъект();
			ТекЗаказ.Статус = СтатусОтгружен;
			Если ТекЗаказ.Проведен Тогда
				ТекЗаказ.Записать(РежимЗаписиДокумента.Проведение);
			Иначе	
				ТекЗаказ.Записать();
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВидДеятельностиПриИзмененииНаСервере()

	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		РеквизитыПодразделения = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Подразделение, "Организация");
		Объект.Организация = РеквизитыПодразделения.Организация;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДеятельностиПриИзменении(Элемент)
	ВидДеятельностиПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПровереноПоУчету(Команда)
	Элементы.КомандаПроверено.Пометка = НЕ Элементы.КомандаПроверено.Пометка;
	Если Элементы.КомандаПроверено.Пометка Тогда
		БюджетныйНаСервере.УстановитьПроверкуДокумента(Объект.Ссылка, Истина);
	Иначе
		БюджетныйНаСервере.УдалитьПроверкуДокумента(Объект.Ссылка, Истина);
	КонецЕсли;
	ОповеститьОбИзменении(Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказКлиентаДок.Ссылка КАК ЗаказКлиента,
	               |	ЗаказКлиентаДок.СуммаДокумента КАК Сумма,
	               |	ЗаказКлиентаДок.Статус КАК Статус,
	               |	ЗаказКлиентаДок.СтатусОплаты КАК СтатусОплаты,
	               |	МАКСИМУМ(ЕСТЬNULL(РеализацияТоваровУслуг.Ссылка, ЕСТЬNULL(УЧ_Реализация.Ссылка, ЕСТЬNULL(ПередачаТоваров.Ссылка, РозничнаяПродажа.Ссылка)))) КАК Реализация,
	               |	ЗаказКлиентаДок.ВесТовара КАК ВесЗаказа,
	               |	ЗаказКлиентаДок.Контрагент КАК Контрагент,
	               |	ЗаказКлиентаДок.ПодразделениеКонтрагента КАК ПодразделениеКонтрагента,
	               |	ЗаказКлиентаДок.ДатаДоставки КАК ВремяДоставки,
	               |	ЗаказКлиентаДок.ДатаДоставкиДо КАК ВремяДоставкиПо
	               |ИЗ
	               |	Документ.ЗаказКлиента КАК ЗаказКлиентаДок
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |		ПО ЗаказКлиентаДок.Ссылка = РеализацияТоваровУслуг.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УЧ_Реализация КАК УЧ_Реализация
	               |		ПО ЗаказКлиентаДок.Ссылка = УЧ_Реализация.ДокОснование
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.сабМаршрутныйЛист.ТабличнаяЧасть КАК сабМаршрутныйЛистТабличнаяЧасть
	               |		ПО ЗаказКлиентаДок.Ссылка = сабМаршрутныйЛистТабличнаяЧасть.ЗаказКлиента
	               |			И (НЕ сабМаршрутныйЛистТабличнаяЧасть.Ссылка.Ссылка = &ЭтаСсылка)
	               |			И (НЕ сабМаршрутныйЛистТабличнаяЧасть.Ссылка.ПометкаУдаления = ЛОЖЬ)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РозничнаяПродажа КАК РозничнаяПродажа
	               |		ПО ЗаказКлиентаДок.Ссылка = РозничнаяПродажа.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПередачаТоваров КАК ПередачаТоваров
	               |		ПО ЗаказКлиентаДок.Ссылка = ПередачаТоваров.Заказ
	               |ГДЕ
	               |	ЗаказКлиентаДок.Статус = &Статус
	               |	И ЗаказКлиентаДок.Предприятие = &Предприятие
	               |	И ВЫБОР
	               |			КОГДА &Доставщик = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЗаказКлиентаДок.Доставщик = &Доставщик
	               |		КОНЕЦ
	               |	И НЕ ЗаказКлиентаДок.СпособДоставки = &СпособДоставки
	               |	И ЗаказКлиентаДок.ДатаПоступления <= &ДатаДокумента
	               |	И ЗаказКлиентаДок.Проведен = ИСТИНА
	               |	И РеализацияТоваровУслуг.Ссылка ЕСТЬ NULL
	               |	И УЧ_Реализация.Ссылка ЕСТЬ NULL
	               |	И сабМаршрутныйЛистТабличнаяЧасть.Ссылка ЕСТЬ NULL
	               |	И ВЫБОР
	               |			КОГДА &МаршрутДоставки = ЗНАЧЕНИЕ(Справочник.МаршрутыДоставки.ПустаяСсылка)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЗаказКлиентаДок.МаршрутДоставки = &МаршрутДоставки
	               |		КОНЕЦ
	               |	И ВЫБОР
	               |			КОГДА &ГрафикДоставки = ЗНАЧЕНИЕ(Справочник.ГрафикиДоставки.ПустаяСсылка)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЗаказКлиентаДок.ГрафикДоставки = &ГрафикДоставки
	               |		КОНЕЦ
	               |	И РозничнаяПродажа.Ссылка ЕСТЬ NULL
	               |	И ПередачаТоваров.Ссылка ЕСТЬ NULL
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЗаказКлиентаДок.Ссылка,
	               |	ЗаказКлиентаДок.СуммаДокумента,
	               |	ЗаказКлиентаДок.Статус,
	               |	ЗаказКлиентаДок.СтатусОплаты,
	               |	ЗаказКлиентаДок.ВесТовара,
	               |	ЗаказКлиентаДок.ПодразделениеКонтрагента,
	               |	ЗаказКлиентаДок.Контрагент,
	               |	ЗаказКлиентаДок.ДатаДоставки,
	               |	ЗаказКлиентаДок.ДатаДоставкиДо
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЗаказНаВозвратОтКлиента.Ссылка,
	               |	ЗаказНаВозвратОтКлиента.СуммаДокумента,
	               |	ЗаказНаВозвратОтКлиента.Статус,
	               |	ЗаказНаВозвратОтКлиента.СтатусОплаты,
	               |	МАКСИМУМ(ЕСТЬNULL(ВозвратТоваровОтПокупателя.Ссылка, ЕСТЬNULL(УЧ_Возврат.Ссылка, РозничнаяПродажа.Ссылка))),
	               |	ЗаказНаВозвратОтКлиента.ВесТовара,
	               |	ЗаказНаВозвратОтКлиента.Контрагент,
	               |	ЗаказНаВозвратОтКлиента.ПодразделениеКонтрагента,
	               |	ЗаказНаВозвратОтКлиента.ДатаДоставки,
	               |	ЗаказНаВозвратОтКлиента.ДатаДоставкиДо
	               |ИЗ
	               |	Документ.ЗаказНаВозвратОтКлиента КАК ЗаказНаВозвратОтКлиента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = ВозвратТоваровОтПокупателя.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УЧ_Возврат КАК УЧ_Возврат
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = УЧ_Возврат.ДокОснование
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.сабМаршрутныйЛист.ТабличнаяЧасть КАК сабМаршрутныйЛистТабличнаяЧасть
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = сабМаршрутныйЛистТабличнаяЧасть.ЗаказКлиента
	               |			И (НЕ сабМаршрутныйЛистТабличнаяЧасть.Ссылка.Ссылка = &ЭтаСсылка)
	               |			И (НЕ сабМаршрутныйЛистТабличнаяЧасть.Ссылка.ПометкаУдаления = ЛОЖЬ)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РозничнаяПродажа КАК РозничнаяПродажа
	               |		ПО ЗаказНаВозвратОтКлиента.Ссылка = РозничнаяПродажа.Заказ
	               |ГДЕ
	               |	ЗаказНаВозвратОтКлиента.Статус = &Статус
	               |	И ЗаказНаВозвратОтКлиента.Предприятие = &Предприятие
	               |	И ВЫБОР
	               |			КОГДА &Доставщик = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЗаказНаВозвратОтКлиента.Доставщик = &Доставщик
	               |		КОНЕЦ
	               |	И НЕ ЗаказНаВозвратОтКлиента.СпособДоставки = &СпособДоставки
	               |	И НАЧАЛОПЕРИОДА(ЗаказНаВозвратОтКлиента.ДатаПоступления, ДЕНЬ) <= &ДатаДокумента
	               |	И ЗаказНаВозвратОтКлиента.Проведен = ИСТИНА
	               |	И ВозвратТоваровОтПокупателя.Ссылка ЕСТЬ NULL
	               |	И УЧ_Возврат.Ссылка ЕСТЬ NULL
	               |	И сабМаршрутныйЛистТабличнаяЧасть.Ссылка ЕСТЬ NULL
	               |	И ВЫБОР
	               |			КОГДА &МаршрутДоставки = ЗНАЧЕНИЕ(Справочник.МаршрутыДоставки.ПустаяСсылка)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЗаказНаВозвратОтКлиента.МаршрутДоставки = &МаршрутДоставки
	               |		КОНЕЦ
	               |	И ВЫБОР
	               |			КОГДА &ГрафикДоставки = ЗНАЧЕНИЕ(Справочник.ГрафикиДоставки.ПустаяСсылка)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЗаказНаВозвратОтКлиента.ГрафикДоставки = &ГрафикДоставки
	               |		КОНЕЦ
	               |	И РозничнаяПродажа.Ссылка ЕСТЬ NULL
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЗаказНаВозвратОтКлиента.Ссылка,
	               |	ЗаказНаВозвратОтКлиента.СуммаДокумента,
	               |	ЗаказНаВозвратОтКлиента.Статус,
	               |	ЗаказНаВозвратОтКлиента.СтатусОплаты,
	               |	ЗаказНаВозвратОтКлиента.ВесТовара,
	               |	ЗаказНаВозвратОтКлиента.ПодразделениеКонтрагента,
	               |	ЗаказНаВозвратОтКлиента.Контрагент,
	               |	ЗаказНаВозвратОтКлиента.ДатаДоставки,
	               |	ЗаказНаВозвратОтКлиента.ДатаДоставкиДо";
	
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыЗаказовКлиентов.КОтгрузке);
	Запрос.УстановитьПараметр("Предприятие", Объект.Предприятие);
	Запрос.УстановитьПараметр("Доставщик", Объект.Доставщик);
	Запрос.УстановитьПараметр("МаршрутДоставки", Объект.МаршрутДоставки);
	Запрос.УстановитьПараметр("СпособДоставки", Справочники.СпособыДоставки.Самовывоз);
	Запрос.УстановитьПараметр("ГрафикДоставки", Объект.ГрафикДоставки);
	Запрос.УстановитьПараметр("ДатаДокумента", КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("ЭтаСсылка", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НайденныеСтроки = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("ЗаказКлиента", Выборка.ЗаказКлиента));
		Если НЕ НайденныеСтроки.Количество() Тогда
			НоваяСтрока = Объект.ТабличнаяЧасть.Добавить();	
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьЗначенияСтрок();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоздатьРеализацииНаСервере(ИмяКоманды)
	Для каждого ТекСтрока Из Объект.ТабличнаяЧасть Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.Реализация) Тогда
			Если ТипЗнч(ТекСтрока.ЗаказКлиента) = Тип("ДокументСсылка.ЗаказНаВозвратОтКлиента") Тогда
				Если ЗначениеЗаполнено(ТекСтрока.ЗаказКлиента.Организация) Тогда
					Если ТекСтрока.ЗаказКлиента.БезвозмезднаяПередача Тогда
						НоваяРеализация = Документы.ОприходованиеТоваров.СоздатьДокумент();
						НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
						НоваяРеализация.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));//всегда непроведенным, т.к. нужно закрывать смену вручную
						ТекСтрока.Реализация = НоваяРеализация.Ссылка; 
					ИначеЕсли ТекСтрока.ЗаказКлиента.ПродажаВРозницу Тогда
						НоваяРеализация = Документы.РозничнаяПродажа.СоздатьДокумент();
						НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
						НоваяРеализация.Записать(РежимЗаписиДокумента.Запись);//всегда непроведенным, т.к. нужно закрывать смену вручную
						ТекСтрока.Реализация = НоваяРеализация.Ссылка; 
					Иначе
						НоваяРеализация = Документы.ВозвратТоваровОтПокупателя.СоздатьДокумент();
						НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
						НоваяРеализация.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
						ТекСтрока.Реализация = НоваяРеализация.Ссылка;
						НовыйСчФ = Документы.СчетФактураВыданный.СоздатьДокумент();
						НовыйСчФ.Заполнить(НоваяРеализация.Ссылка);
						НовыйСчФ.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
					КонецЕсли;
				Иначе	
					НоваяРеализация = Документы.УЧ_Возврат.СоздатьДокумент();
					НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
					НоваяРеализация.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
					ТекСтрока.Реализация = НоваяРеализация.Ссылка; 
				КонецЕсли;
				
			Иначе
				Если ЗначениеЗаполнено(ТекСтрока.ЗаказКлиента.Организация) Тогда
					Если ТекСтрока.ЗаказКлиента.БезвозмезднаяПередача Тогда
						НоваяРеализация = Документы.ПередачаТоваров.СоздатьДокумент();
						НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
						НоваяРеализация.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));//всегда непроведенным, т.к. нужно закрывать смену вручную
						ТекСтрока.Реализация = НоваяРеализация.Ссылка; 
					ИначеЕсли ТекСтрока.ЗаказКлиента.ПродажаВРозницу Тогда
						НоваяРеализация = Документы.РозничнаяПродажа.СоздатьДокумент();
						НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
						НоваяРеализация.Записать(РежимЗаписиДокумента.Запись);//всегда непроведенным, т.к. нужно закрывать смену вручную
						ТекСтрока.Реализация = НоваяРеализация.Ссылка; 
					Иначе
						НоваяРеализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
						НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
						НоваяРеализация.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
						ТекСтрока.Реализация = НоваяРеализация.Ссылка;
						Если СоздаватьСчетНаОплатуПокупателю Тогда
							НовыйСчет = Документы.СчетНаОплатуПокупателю.СоздатьДокумент();
							НовыйСчет.Заполнить(НоваяРеализация.Ссылка);
							Попытка
								НовыйСчет.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));				
							Исключение
								НовыйСчет.Записать();				
							КонецПопытки;
							НоваяРеализация.СчетНаОплатуПокупателю = НовыйСчет.Ссылка;
							НоваяРеализация.Записать();
						КонецЕсли;
						НовыйСчФ = Документы.СчетФактураВыданный.СоздатьДокумент();
						НовыйСчФ.Заполнить(НоваяРеализация.Ссылка);
						НовыйСчФ.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
					КонецЕсли;
				Иначе	
					НоваяРеализация = Документы.УЧ_Реализация.СоздатьДокумент();
					НоваяРеализация.Заполнить(ТекСтрока.ЗаказКлиента);
					НоваяРеализация.Записать(?(ПроводитьДокументы, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
					ТекСтрока.Реализация = НоваяРеализация.Ссылка; 
				КонецЕсли;
			КонецЕсли;

			
		КонецЕсли;
	КонецЦикла;
	Записать();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеализации(Команда)
	СоздатьРеализацииНаСервере(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьЗаказКлиентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("Заказы клиента");
	СписокВыбора.Добавить("Заказы на возврат клиента");
	ТекЗнач = Неопределено;

	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ТабличнаяЧастьЗаказКлиентаНачалоВыбораЗавершение", ЭтаФорма), СписокВыбора, Элемент, СписокВыбора.НайтиПоЗначению("Заказы клиента"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьЗаказКлиентаНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	ТекЗнач = ВыбранныйЭлемент;
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	Если ТекЗнач.Значение = "Заказы клиента" Тогда
		
		МассивЗаказовВМЛ = ПолучитьМассивЗаказов();
		ПараметрыФормы = Новый Структура("Статус, УжеВыбрано", ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.КОтгрузке"), МассивЗаказовВМЛ);
		ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбораЗаказа", ЭтаФорма);
		ОткрытьФорму("Документ.ЗаказКлиента.ФормаВыбора", ПараметрыФормы, ЭтаФорма, , , , ОбработкаВыбора);
		
	ИначеЕсли ТекЗнач.Значение = "Заказы на возврат клиента" Тогда	
		
		МассивЗаказовВМЛ = ПолучитьМассивЗаказов();
		ПараметрыФормы = Новый Структура("Статус, УжеВыбрано", ПредопределенноеЗначение("Перечисление.СтатусыЗаказовКлиентов.КОтгрузке"), МассивЗаказовВМЛ);
		ОбработкаВыбора = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбораЗаказа", ЭтаФорма);
		ОткрытьФорму("Документ.ЗаказНаВозвратОтКлиента.ФормаВыбора", ПараметрыФормы, ЭтаФорма, , , , ОбработкаВыбора);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ТабличнаяЧастьПриОкончанииРедактированияНаСервере(); 
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьПриОкончанииРедактированияНаСервере()
	
 	СтатусОтгружен = Перечисления.СтатусыЗаказовКлиентов.Отгружен;
	ЕстьНеотгруженные = Ложь;
	Для каждого ТекСтрока Из Объект.ТабличнаяЧасть Цикл
		Если НЕ ТекСтрока.Статус = СтатусОтгружен Тогда
			ЕстьНеотгруженные = Истина;
			Прервать;		
		КонецЕсли;	
	КонецЦикла;
	Объект.Выполнен = Не ЕстьНеотгруженные;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЕстьНеобновленныеРеализации Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтаФорма), "Есть незаполненные реализации. Обновить?", РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутДоставкиПриИзменении(Элемент)
	Если Объект.ТабличнаяЧасть.Количество() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("МаршрутДоставкиПриИзмененииЗавершение", ЭтаФорма), "Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МаршрутДоставкиПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ТабличнаяЧасть.Очистить();		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытииФормыВыбораЗаказа(Значение, ДополнительныеПараметры) Экспорт
	
	Если Значение = Неопределено Тогда
        Возврат;
    КонецЕсли;
     
    Элементы.ТабличнаяЧасть.ТекущиеДанные.ЗаказКлиента = Значение; 
	
КонецПроцедуры     

&НаСервере
Функция ПолучитьМассивЗаказов()  
	ТЗ = Объект.ТабличнаяЧасть.Выгрузить(,"ЗаказКлиента");
	Возврат ТЗ.ВыгрузитьКолонку("ЗаказКлиента");
КонецФункции	


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьЗначенияСтрок();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияСтрок()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаказКлиента.Контрагент КАК Контрагент,
	|	ЗаказКлиента.ДатаПоступления КАК ДатаПоступления,
	|	ЗаказКлиента.ПродажаВРозницу КАК ПродажаВРозницу,
	|	ЗаказКлиента.АдресДоставки КАК АдресДоставки,
	|	ЗаказКлиента.БезвозмезднаяПередача КАК БезвозмезднаяПередача,
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В(&Заказы)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказНаВозвратОтКлиента.Контрагент,
	|	ЗаказНаВозвратОтКлиента.ДатаПоступления,
	|	ЗаказНаВозвратОтКлиента.ПродажаВРозницу,
	|	ЗаказНаВозвратОтКлиента.АдресДоставки,
	|	ЗаказНаВозвратОтКлиента.БезвозмезднаяПередача,
	|	ЗаказНаВозвратОтКлиента.Ссылка
	|ИЗ
	|	Документ.ЗаказНаВозвратОтКлиента КАК ЗаказНаВозвратОтКлиента
	|ГДЕ
	|	ЗаказНаВозвратОтКлиента.Ссылка В(&Заказы)";
	
	Запрос.УстановитьПараметр("Заказы", Объект.ТабличнаяЧасть.Выгрузить().ВыгрузитьКолонку("ЗаказКлиента"));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НайденныеСтроки = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("ЗаказКлиента", Выборка.ЗаказКлиента));
		Для каждого ТекНайдСтрока Из НайденныеСтроки Цикл
			ЗаполнитьЗначенияСвойств(ТекНайдСтрока, Выборка);
		КонецЦикла;
		
	КонецЦикла;
	
	
КонецПроцедуры


