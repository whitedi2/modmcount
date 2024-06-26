﻿
&НаКлиенте
Процедура Команда1(Команда)
	Для каждого ТекСтрока Из СписокДоков Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Значение) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Значение пустое";
			Сообщение.Поле = "СписокДоков[" + Строка(СписокДоков.Индекс(ТекСтрока)) + "].Значение"; //имя реквизита
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;	
	КонецЦикла;
	
	Для каждого ТекСтрока Из Подразделение Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Значение) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Значение пустое";
			Сообщение.Поле = "Подразделение[" + Строка(СписокДоков.Индекс(ТекСтрока)) + "].Значение"; //имя реквизита
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;	
	КонецЦикла;
	
	Для каждого ТекСтрока Из Номенклатура Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Значение) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Значение пустое";
			Сообщение.Поле = "Номенклатура[" + Строка(СписокДоков.Индекс(ТекСтрока)) + "].Значение"; //имя реквизита
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;	
	КонецЦикла;
	
	Для каждого ТекСтрока Из счет Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Значение) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Значение пустое";
			Сообщение.Поле = "счет[" + Строка(СписокДоков.Индекс(ТекСтрока)) + "].Значение"; //имя реквизита
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;	
	КонецЦикла;
	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОписаниеВопрос", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, "Выполнить перепроведение?",РежимДиалогаВопрос.ДаНет, 60);
КонецПроцедуры

//Вынести в отдельную процедуру
&НаКлиенте
Процедура ОписаниеВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполнитьПерепроведение();	
	КонецЕсли; 
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьПерепроведение()
	
	Обработ = АА3();
	счСтроки = 0;
	ВремяНачала = ТекущаяДата();   
	ЧислоСтрок  = Обработ.Количество();
	Продолжение = Истина;
	
	Для каждого ТекОбр Из Обработ Цикл
		
		ТекущаяСкорость = ТекущаяДата();
		счСтроки = счСтроки + 1;
		СкоростьЗагрузки = ?(ТекущаяДата() - ВремяНачала = 0, 0, Окр(счСтроки / (ТекущаяДата() - ВремяНачала), 2));
		ОсталосьВремени = Окр((ТекущаяДата() - ВремяНачала) / счСтроки * (ЧислоСтрок - счСтроки) / 60, 2);
		
		Если счСтроки / 100 = Окр(счСтроки / 100, 0) ИЛИ СкоростьЗагрузки < 1 ИЛИ ЧислоСтрок < 100 ИЛИ СкоростьЗагрузки < 5 Тогда
			Состояние("Обработка..." + " Осталось " + Строка(ОсталосьВремени) + " мин." + " Скорость " + Строка(СкоростьЗагрузки) + " стр/сек",
			счСтроки / ЧислоСтрок * 100, "№ дока: " +  Строка(ТекОбр.Ссылка) +
			" (" + Строка(счСтроки) + "/" + Строка(ЧислоСтрок) + ")" );
		КонецЕсли;
		
		ПоследнийДокумент = ТекОбр.Ссылка;
		Зап4(ТекОбр, ТолькоЗапись, ПеревинутьВремяВВДокументах, НовоеВремяДокументов, НовоеВремяДокументовМин, НеКонтролироватьОтрицательныеОстатки, НеКонтролироватьЗаполнениеДокумента);
		
		Если ТекОбр.Свойство("ТекстОшибки") И НЕ НеКонтролироватьЗаполнениеДокумента Тогда
			Сообщить(ТекОбр.ТекстОшибки + " " + Строка(ТекОбр.Ссылка));
			Прервать;		
		КонецЕсли;
		
		Если ТекОбр.Свойство("НехваткаОстатков") И ПрерыватьПриУходеВМинус Тогда
			Сообщить("Прервано по причине нехватки остатков " + Строка(ТекОбр.Ссылка));
			Прервать;		
		КонецЕсли;
		
		ТекущаяСкорость = ТекущаяДата() - ТекущаяСкорость;
		
		ОбработкаПрерыванияПользователя();
		
	КонецЦикла; 
	
КонецПроцедуры

Функция АА3()
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УчетныйОбороты.Регистратор КАК Ссылка,
	               |	УчетныйОбороты.Регистратор.Дата КАК Дата,
	               |	УчетныйОбороты.Регистратор.Номер КАК РегистраторНомер
	               |ПОМЕСТИТЬ РегистраторыУЧ
	               |ИЗ
	               |	РегистрБухгалтерии.Учетный.Обороты(
	               |			&Дата,
	               |			&Дата1,
	               |			Регистратор,
	               |			Счет В ИЕРАРХИИ (&Счет)
	               |				ИЛИ Счет В ИЕРАРХИИ (&ДенСчета),
	               |			,
	               |			ВЫБОР
	               |					КОГДА ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) В (&Подразделение)
	               |						ТОГДА ИСТИНА
	               |					ИНАЧЕ Подразделение В ИЕРАРХИИ (&Подразделение)
	               |				КОНЕЦ
	               |				И ВЫБОР
	               |					КОГДА ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) В (&Номенклатура)
	               |						ТОГДА ИСТИНА
	               |					ИНАЧЕ Субконто1 В ИЕРАРХИИ (&Номенклатура)
	               |				КОНЕЦ
	               |				И СценарийПлана = &СценарийФакт,
	               |			,
	               |			) КАК УчетныйОбороты
	               |ГДЕ
	               |	ВЫБОР
	               |			КОГДА &ВсеТипы
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ВЫБОР
	               |					КОГДА ТИП(Документ.УЧ_ПеремещениеТоваров) В (&ТипыДокументов)
	               |						ТОГДА НЕ ТИПЗНАЧЕНИЯ(УчетныйОбороты.Регистратор) = ТИП(Документ.УЧ_ПеремещениеТоваров)
	               |								И ТИПЗНАЧЕНИЯ(УчетныйОбороты.Регистратор) В (&ТипыДокументов)
	               |					ИНАЧЕ ТИПЗНАЧЕНИЯ(УчетныйОбороты.Регистратор) В (&ТипыДокументов)
	               |				КОНЕЦ
	               |		КОНЕЦ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	УчетныйОбороты.Регистратор,
	               |	УчетныйОбороты.Регистратор.Дата,
	               |	УчетныйОбороты.Регистратор.Номер
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УЧ_Реализация.Ссылка КАК Ссылка,
	               |	УЧ_Реализация.Дата КАК Дата,
	               |	УЧ_Реализация.Номер КАК Номер
	               |ПОМЕСТИТЬ Регистраторы
	               |ИЗ
	               |	Документ.УЧ_Реализация КАК УЧ_Реализация
	               |ГДЕ
	               |	УЧ_Реализация.Проведен = ИСТИНА
	               |	И УЧ_Реализация.Дата МЕЖДУ &Дата И &Дата1
	               |	И (&ВсеТипы = ИСТИНА
	               |			ИЛИ ТИП(Документ.УЧ_Реализация) В (&ТипыДокументов))
	               |	И ВЫРАЗИТЬ(УЧ_Реализация.Товары.Номенклатура КАК Справочник.Номенклатура).Счет10 В ИЕРАРХИИ (&Счет)
	               |	И ВЫБОР
	               |			КОГДА ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) В (&Подразделение)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ УЧ_Реализация.Подразделение В ИЕРАРХИИ (&Подразделение)
	               |		КОНЕЦ
	               |	И ВЫБОР
	               |			КОГДА ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) В (&Номенклатура)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЛОЖЬ
	               |		КОНЕЦ
	               |	И НЕ УЧ_Реализация.Ссылка В
	               |				(ВЫБРАТЬ
	               |					РегистраторыУЧ.Ссылка
	               |				ИЗ
	               |					РегистраторыУЧ КАК РегистраторыУЧ)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	УЧ_ВыпускПродукции.Ссылка,
	               |	УЧ_ВыпускПродукции.Дата,
	               |	УЧ_ВыпускПродукции.Номер
	               |ИЗ
	               |	Документ.УЧ_ВыпускПродукции КАК УЧ_ВыпускПродукции
	               |ГДЕ
	               |	УЧ_ВыпускПродукции.Проведен = ИСТИНА
	               |	И УЧ_ВыпускПродукции.Дата МЕЖДУ &Дата И &Дата1
	               |	И (&ВсеТипы = ИСТИНА
	               |			ИЛИ ТИП(Документ.УЧ_ВыпускПродукции) В (&ТипыДокументов))
	               |	И (УЧ_ВыпускПродукции.ТабличнаяЧасть.Номенклатура.Счет10 В ИЕРАРХИИ (&Счет)
	               |			ИЛИ УЧ_ВыпускПродукции.Материалы.Материал.Счет10 В ИЕРАРХИИ (&Счет))
	               |	И ВЫБОР
	               |			КОГДА ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) В (&Подразделение)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ УЧ_ВыпускПродукции.Подразделение В ИЕРАРХИИ (&Подразделение)
	               |		КОНЕЦ
	               |	И ВЫБОР
	               |			КОГДА ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) В (&Номенклатура)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЛОЖЬ
	               |		КОНЕЦ
	               |	И НЕ УЧ_ВыпускПродукции.Ссылка В
	               |				(ВЫБРАТЬ
	               |					РегистраторыУЧ.Ссылка
	               |				ИЗ
	               |					РегистраторыУЧ КАК РегистраторыУЧ)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	УЧ_ПеремещениеТоваров.Ссылка,
	               |	УЧ_ПеремещениеТоваров.Дата,
	               |	УЧ_ПеремещениеТоваров.Номер
	               |ИЗ
	               |	Документ.УЧ_ПеремещениеТоваров КАК УЧ_ПеремещениеТоваров
	               |ГДЕ
	               |	УЧ_ПеремещениеТоваров.Проведен = ИСТИНА
	               |	И УЧ_ПеремещениеТоваров.Дата МЕЖДУ &Дата И &Дата1
	               |	И (&ВсеТипы = ИСТИНА
	               |			ИЛИ ТИП(Документ.УЧ_ПеремещениеТоваров) В (&ТипыДокументов))
	               |	И УЧ_ПеремещениеТоваров.ТабличнаяЧасть.Номенклатура.Счет10 В ИЕРАРХИИ(&Счет)
	               |	И ВЫБОР
	               |			КОГДА ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) В (&Подразделение)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ВЫБОР
	               |					КОГДА УЧ_ПеремещениеТоваров.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыПеремещений.ПоступлениеСОбособленногоПодразделения)
	               |						ТОГДА УЧ_ПеремещениеТоваров.ПодразделениеПолучатель В ИЕРАРХИИ (&Подразделение)
	               |					ИНАЧЕ УЧ_ПеремещениеТоваров.Подразделение В ИЕРАРХИИ (&Подразделение)
	               |				КОНЕЦ
	               |		КОНЕЦ
	               |	И ВЫБОР
	               |			КОГДА ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) В (&Номенклатура)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЛОЖЬ
	               |		КОНЕЦ
	               |	И НЕ УЧ_ПеремещениеТоваров.Ссылка В
	               |				(ВЫБРАТЬ
	               |					РегистраторыУЧ.Ссылка
	               |				ИЗ
	               |					РегистраторыУЧ КАК РегистраторыУЧ)
	               |	И (&ВсеТипы = ИСТИНА
	               |			ИЛИ ВЫБОР
	               |				КОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПеремещений.ПустаяСсылка) В (&ВидОперации)
	               |					ТОГДА ИСТИНА
	               |				ИНАЧЕ УЧ_ПеремещениеТоваров.ВидОперации В (&ВидОперации)
	               |			КОНЕЦ)
	               |	И (&ВсеТипы = ИСТИНА
	               |			ИЛИ ВЫБОР
	               |				КОГДА ""Все"" В (&ДопПризнакВнутр)
	               |					ТОГДА ИСТИНА
	               |				КОГДА ""Отправитель-получатель равны"" В (&ДопПризнакВнутр)
	               |					ТОГДА УЧ_ПеремещениеТоваров.Подразделение = УЧ_ПеремещениеТоваров.ПодразделениеПолучатель
	               |				КОГДА ""Отправитель-получатель НЕ равны"" В (&ДопПризнакВнутр)
	               |					ТОГДА НЕ УЧ_ПеремещениеТоваров.Подразделение = УЧ_ПеремещениеТоваров.ПодразделениеПолучатель
	               |				ИНАЧЕ ИСТИНА
	               |			КОНЕЦ)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	РегистраторыУЧ.Ссылка,
	               |	РегистраторыУЧ.Дата,
	               |	РегистраторыУЧ.РегистраторНомер
	               |ИЗ
	               |	РегистраторыУЧ КАК РегистраторыУЧ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Регистраторы.Ссылка КАК Ссылка,
	               |	Регистраторы.Дата КАК Дата,
	               |	Регистраторы.Номер КАК Номер
	               |ИЗ
	               |	Регистраторы КАК Регистраторы
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Регистраторы.Ссылка,
	               |	Регистраторы.Дата,
	               |	Регистраторы.Номер
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Регистраторы.Ссылка.МоментВремени,
	               |	Дата,
	               |	Номер
	               |АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Счет", ?(Счет.Количество(), Счет.ВыгрузитьЗначения(), Элементы.счетЗначение.СписокВыбора.ВыгрузитьЗначения()));
	Запрос.УстановитьПараметр("Подразделение", ?(Подразделение.Количество(), Подразделение.ВыгрузитьЗначения(), Справочники.СтруктураПредприятия.ПустаяСсылка()));
	Запрос.УстановитьПараметр("Номенклатура", ?(Номенклатура.Количество(), Номенклатура.ВыгрузитьЗначения(), Справочники.Номенклатура.ПустаяСсылка()));
	Запрос.УстановитьПараметр("ВсеТипы", НЕ СписокДоков.Количество());
	Запрос.УстановитьПараметр("ТипыДокументов", СписокДоков.Выгрузить().ВыгрузитьКолонку("Значение"));
	Запрос.УстановитьПараметр("ДопПризнакВнутр", СписокДоков.Выгрузить().ВыгрузитьКолонку("ДопПоВнутрПеремещениям"));
	Запрос.УстановитьПараметр("СценарийФакт", Справочники.СценарииПланирования.СценарийФакт());
	
	Если НеПерепроводитьДвиженияДС Тогда
		Запрос.УстановитьПараметр("ДенСчета", Неопределено);
	Иначе
		ДенСчета = Новый Массив;
		ДенСчета.Добавить(ПланыСчетов.Учетный.Счет50());
		ДенСчета.Добавить(ПланыСчетов.Учетный.Счет51());
		ДенСчета.Добавить(ПланыСчетов.Учетный.Счет5501());
		Запрос.УстановитьПараметр("ДенСчета", ДенСчета);
	КонецЕсли;
	
	МассивВидовОпераций = Новый Массив;
	Для каждого ТекСтрока Из СписокДоков Цикл
		Если ТекСтрока.Значение = Тип("ДокументСсылка.УЧ_ПеремещениеТоваров") Тогда
			Если Не ЗначениеЗаполнено(ТекСтрока.ВидОперации) Тогда
				МассивВидовОпераций.Добавить(Перечисления.ВидыПеремещений.ПустаяСсылка());
			Иначе
				МассивВидовОпераций.Добавить(ТекСтрока.ВидОперации);			
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Запрос.УстановитьПараметр("ВидОперации", МассивВидовОпераций);
	
	
	Результат = Запрос.Выполнить();
	
	Массив = Новый Массив;
	//Сообщить(Результат.Выгрузить().Количество());
	//Возврат Массив;
	Выборка = Результат.Выгрузить();
	Для каждого ТекСТрока Из Выборка Цикл
		Массив.Добавить(Новый Структура("Ссылка, Значение, НеКонтролироватьОтрицательныеОстатки", ТекСТрока.Ссылка, НеКонтролироватьОтрицательныеОстатки));
		
	КонецЦикла;
	
	Возврат Массив;
	
	//Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	
КонецФункции

Процедура Зап4(Объект, ТолькоЗапись, ПеревинутьВремяВВДокументах, НовоеВремяДокументов, НовоеВремяДокументовМин, НеКонтролироватьОтрицательныеОстатки, НеКонтролироватьЗаполнениеДокумента)
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.УЧ_ЗакрытиеПериода") И НеПерепроводитьЗакрытиеПериода Тогда
		Возврат;
	КонецЕсли;
	
	Об = Объект.Ссылка.ПолучитьОбъект();
	
	Если ПеревинутьВремяВВДокументах Тогда
		Об.Дата = НачалоДня(Об.Дата) + НовоеВремяДокументов*60*60 + НовоеВремяДокументовМин*60;
		Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.УЧ_ПеремещениеТоваров") И Объект.Ссылка.ВидОперации = Перечисления.ВидыПеремещений.ПоступлениеСОбособленногоПодразделения Тогда
			Об.Дата = Об.Дата + 1;		
		КонецЕсли;
	КонецЕсли;
	
	Об.ДополнительныеСвойства.Вставить("НеКонтролироватьОтрицательныеОстатки", НеКонтролироватьОтрицательныеОстатки);
	Успешно = Ложь;
	КолвоИтераций = 0;
	Если Об.Проведен И НЕ ТолькоЗапись Тогда
		//Пока НЕ Успешно И КолвоИтераций < 5 Цикл
		Попытка
			Если НЕ НеКонтролироватьЗаполнениеДокумента Тогда
				Если НЕ Об.ПроверитьЗаполнение() Тогда
					Объект.Вставить("ТекстОшибки", "Ошибка проверки заполнения");
					УстановитьПривилегированныйРежим(Ложь);
					Возврат;
				КонецЕсли;
			КонецЕсли;			
			Об.Записать(РежимЗаписиДокумента.Проведение);
			Успешно = Истина;
		Исключение
			//Об.Записать(РежимЗаписиДокумента.Проведение);
			Если Об.ДополнительныеСвойства.Свойство("НехваткаОстатков") Тогда
				Объект.Вставить("НехваткаОстатков", "Нехватка остатков");
				УстановитьПривилегированныйРежим(Ложь);
				Возврат;
			Иначе
				Объект.Вставить("ТекстОшибки", "Ошибка проведения");
			КонецЕсли;
			КолвоИтераций = КолвоИтераций + 1;
		КонецПопытки;
		
		Если КолвоИтераций = 5 Тогда
			Объект.Вставить("ТекстОшибки", "Блокировка записи");		
		КонецЕсли;
	Иначе
		Об.Записать();	
	КонецЕсли;
	//УстановитьМонопольныйРежим(Ложь);	
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НеКонтролироватьЗаполнениеДокумента = Истина;
	ТолькоПроведенные = Истина;
	
	Элементы.счетЗначение.РежимВыбораИзСписка = Истина;
	Элементы.счетЗначение.СписокВыбора.Добавить(ПланыСчетов.Учетный.Счет41());
	Элементы.счетЗначение.СписокВыбора.Добавить(ПланыСчетов.Учетный.Счет43());
	Элементы.счетЗначение.СписокВыбора.Добавить(ПланыСчетов.Учетный.Счет10());
	Элементы.счетЗначение.СписокВыбора.Добавить(ПланыСчетов.Учетный.Счет45());
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДоковЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Спис = Новый СписокЗначений;
	Спис.Добавить(Тип("ДокументСсылка.УЧ_ПоступлениеТоваров"));
	Спис.Добавить(Тип("ДокументСсылка.УЧ_ПеремещениеТоваров")); //
	Спис.Добавить(Тип("ДокументСсылка.УЧ_СписаниеТоваров"));//
	Спис.Добавить(Тип("ДокументСсылка.УЧ_ВозвратТоваровПоставщику")); //
	Спис.Добавить(Тип("ДокументСсылка.УЧ_ВыпускПродукции"));//
	Спис.Добавить(Тип("ДокументСсылка.УЧ_ПереводТМЦ"));//
	Спис.Добавить(Тип("ДокументСсылка.Уч_Сторно"));
	Спис.Добавить(Тип("ДокументСсылка.УЧ_Реализация"));  //
	Спис.Добавить(Тип("ДокументСсылка.УЧ_ВозвратГПВПереработку"));
	//Спис.Добавить(Тип("ДокументСсылка.УЧ_ВыпускПобочнойПродукции"));
	
	ТекЗначк = ВыбратьИзСписка(Спис, Элемент);
	Если НЕ ТекЗначк = Неопределено Тогда
		//ДанныеВыбора = ТекЗначк.Значение;
		НоваяСтрока = СписокДоков.Добавить();
		НоваяСтрока.Значение = ТекЗначк.Значение;
		Элементы.СписокДоков.ЗакончитьРедактированиеСтроки(Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура счетЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	//Спис = Новый СписокЗначений;
	//
	//
	//ТекЗначк = ВыбратьИзСписка(Спис, Элемент);
	//Если НЕ ТекЗначк = Неопределено Тогда
	//	ДанныеВыбора = ТекЗначк.Значение;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НеКонтролироватьОтрицательныеОстаткиПриИзменении(Элемент)
	Элементы.ПрерыватьПриУходеВМинус.Доступность = НЕ НеКонтролироватьОтрицательныеОстатки;
	Если НЕ Элементы.ПрерыватьПриУходеВМинус.Доступность Тогда
		ПрерыватьПриУходеВМинус = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоМинусовымОстаткамНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	сабКешОстатков.Номенклатура
	               |ИЗ
	               |	РегистрСведений.сабКешОстатков КАК сабКешОстатков
	               |ГДЕ
	               |	сабКешОстатков.Количество < 0
	               |	И сабКешОстатков.Период МЕЖДУ &Дата И &Дата1
	               |	И ВЫБОР
	               |			КОГДА ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) В (&Подразделение)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ сабКешОстатков.Подразделение В (&Подразделение)
	               |		КОНЕЦ
	               |	И сабКешОстатков.Счет В ИЕРАРХИИ(&Счет)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	сабКешОстатков.Номенклатура";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Счет", ?(Счет.Количество(), Счет.ВыгрузитьЗначения(), Элементы.счетЗначение.СписокВыбора.ВыгрузитьЗначения()));
	Запрос.УстановитьПараметр("Подразделение", ?(Подразделение.Количество(), Подразделение.ВыгрузитьЗначения(), Справочники.СтруктураПредприятия.ПустаяСсылка()));
	Запрос.УстановитьПараметр("Номенклатура", ?(Номенклатура.Количество(), Номенклатура.ВыгрузитьЗначения(), Справочники.Номенклатура.ПустаяСсылка()));
	Запрос.УстановитьПараметр("ВсеТипы", НЕ СписокДоков.Количество());
	Запрос.УстановитьПараметр("ТипыДокументов", СписокДоков.ВыгрузитьЗначения());	
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выгрузить();
	
	//Если Не Выборка.Количество() Тогда
	//	Сообщить("Кеш остатков пуст за указанный период!");	
	//КонецЕсли;
	
	Номенклатура.Очистить();
	Для каждого ТекСТрока Из Выборка Цикл
		НоваяСтрока = Номенклатура.Добавить();
		НоваяСтрока.Значение = ТекСТрока.Номенклатура;
		
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоМинусовымОстаткам(Команда)
	ЗаполнитьПоМинусовымОстаткамНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПеревинутьВремяВВыпускахПриИзменении(Элемент)
	Элементы.НовоеВремяДокументов.Доступность = ПеревинутьВремяВВДокументах;
	Элементы.НовоеВремяДокументовМин.Доступность = ПеревинутьВремяВВДокументах;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НеКонтролироватьОтрицательныеОстаткиПриИзменении(Неопределено);
	ПеревинутьВремяВВыпускахПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СписокДоковПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.СписокДоков.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		ТекДанные.ИспользуетсяВид = ТекДанные.Значение = Тип("ДокументСсылка.УЧ_ПеремещениеТоваров");
		
		Если ТекДанные.Значение = Тип("ДокументСсылка.УЧ_ПеремещениеТоваров") Тогда
			Масс = Новый Массив;
			Масс.Добавить(Тип("ПеречислениеСсылка.ВидыПеремещений"));
			Тип = Новый ОписаниеТипов(Масс);;
			Элементы.СписокДоковВидОперации.ОграничениеТипа = Тип;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Дата = Период.ДатаНачала;
	Дата1 = Период.ДатаОкончания;
КонецПроцедуры
