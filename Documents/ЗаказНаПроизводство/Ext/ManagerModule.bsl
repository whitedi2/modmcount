﻿
Функция ВвестиНаОсновании(ДокОснование) Экспорт
	
	МассивДокументов = Новый Массив;
		
	Если ТипЗнч(ДокОснование) = Тип("ДокументСсылка.ПланПроизводства") Тогда
		ТЧМатериалов = ДокОснование.Сырье.Выгрузить();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланПроизводстваТовары.Спецификация.Цех КАК Цех,
		|	ПланПроизводстваТовары.Спецификация,
		|	ПланПроизводстваТовары.Номенклатура,
		|	ПланПроизводстваТовары.КоличествоКЗаказу КАК Количество
		|ИЗ
		|	Документ.ПланПроизводства.Товары КАК ПланПроизводстваТовары
		|ГДЕ
		|	ПланПроизводстваТовары.Ссылка = &Ссылка
		|	И ПланПроизводстваТовары.СпособОбеспечения = &СпособОбеспечения
		|	И ПланПроизводстваТовары.КоличествоКЗаказу > 0
		|ИТОГИ ПО
		|	Цех";
		Запрос.УстановитьПараметр("Ссылка", ДокОснование);
		Запрос.УстановитьПараметр("СпособОбеспечения", Перечисления.ТипыОбеспеченияПотребности.Производство);
		
		ВыборкаПоЦехам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоЦехам.Следующий() Цикл
			ДокЗаказа = Документы.ЗаказНаПроизводство.СоздатьДокумент();
			ДокЗаказа.Дата = ТекущаяДата();
			ДокЗаказа.Предприятие = ДокОснование.Предприятие;
			ДокЗаказа.Цех = ВыборкаПоЦехам.Цех;
			ДокЗаказа.Склад = ВыборкаПоЦехам.Цех.Склад;
			ДокЗаказа.ДокОснование = ДокОснование;
			ДокЗаказа.Подразделение = ДокОснование.Подразделение;
			ВыборкаПоНоменклатуре = ВыборкаПоЦехам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоНоменклатуре.Следующий() Цикл
				СтрокаТЧНоменклатур = ДокЗаказа.ТабличнаяЧасть.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЧНоменклатур, ВыборкаПоНоменклатуре);
				СтрокаТЧНоменклатур.УИД = Новый УникальныйИдентификатор;
				НайденныеСтрокиМатериалов = ТЧМатериалов.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТЧНоменклатур.Номенклатура));
				Для Каждого НайденнаяСтрокаМатериалов Из НайденныеСтрокиМатериалов Цикл
					СтрокаМатериалов = ДокЗаказа.Материалы.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаМатериалов, НайденнаяСтрокаМатериалов);
					СтрокаМатериалов.Материал = НайденнаяСтрокаМатериалов.Ингредиент;
					СтрокаМатериалов.УИДТЧ = СтрокаТЧНоменклатур.УИД;
				КонецЦикла;	
			КонецЦикла;
			ДокЗаказа.Записать();
			МассивДокументов.Добавить(ДокЗаказа.Ссылка);
		КонецЦикла;	
	КонецЕсли;	
	
	Возврат МассивДокументов;
	
КонецФункции	

Функция ТабличнаяЧастьНоменклатураПриИзмененииНаСервере(ТекНоменклатура) Экспорт
	
	Если ЗначениеЗаполнено(ТекНоменклатура.ОсновнаяСпецификацияНоменклатуры) Тогда 
		Возврат ТекНоменклатура.ОсновнаяСпецификацияНоменклатуры;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Спецификации.Ссылка
	|ИЗ
	|	Справочник.СпецификацииНоменклатуры КАК Спецификации
	|ГДЕ
	|	Спецификации.Владелец = &Продукция
	//|	И Спецификации.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыСпецификаций.ГотоваяПродукция)
	|	И НЕ Спецификации.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Спецификации.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Продукция", ТекНоменклатура);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Ссылка;
	КонецЦикла;
	
	Возврат Справочники.СпецификацииНоменклатуры.ПустаяСсылка();
	
КонецФункции
