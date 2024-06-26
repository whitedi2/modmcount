﻿
&После("ПередЗаписью")
Процедура УУ_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)  
	
	//Синхронизация серий
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда 
		Если Не ЭтоНовый() Тогда 
			сабОперОбщегоНазначения.СинхронизацияНомераСтрокиОсновнойТЧССериямиБух(Товары,Ссылка.Товары,СерииНоменклатуры,ЭтотОбъект);
		КонецЕсли;
		сабОперОбщегоНазначения.ПерезаполнитьТЧСерииНоменклатурыПередЗаписью(Товары,СерииНоменклатуры,Истина);
	КонецЕсли;

КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура УУ_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер, Проведен");
		ЭтотОбъект.ВидОперации = Перечисления.ВидыПоступлений.Поступление;
		ЭтотОбъект.Заказ = ДанныеЗаполнения;
		ЭтотОбъект.СуммаВключаетНДС = Истина;
		ЭтотОбъект.НДСВключенВСтоимость = Ложь;
		ЭтотОбъект.ДоговорКонтрагента = ДанныеЗаполнения.Договор;
		ЭтотОбъект.ТипЦен = ЭтотОбъект.ДоговорКонтрагента.ТипЦен;
		ЭтотОбъект.Дата = ДанныеЗаполнения.ДатаПоступления;
		ЭтотОбъект.ЭтоУниверсальныйДокумент = Истина;
		ЭтотОбъект.ВалютаДокумента = ДанныеЗаполнения.Валюта;
		//Ответственным текущий пользователь
		ЭтотОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		//
		Если Не ЗначениеЗаполнено(ЭтотОбъект.ВалютаДокумента) Тогда
			ЭтотОбъект.ВалютаДокумента = УЧ_Сервер.НациональнаяВалюта();		
		КонецЕсли;
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
			
			Если Не ЗначениеЗаполнено(ЭтотОбъект.Склад) Тогда
				ЭтотОбъект.Склад = ТекСтрока.Склад;	
			КонецЕсли;  
			
		КонецЦикла;
		
		НовОбъект = Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовОбъект, ДанныеЗаполнения,,"Дата, Номер");
		НовОбъект.ВидОперации = Перечисления.ВидыПоступлений.Поступление;
		НовОбъект.Заказ = ДанныеЗаполнения;
		НовОбъект.СуммаВключаетНДС = Истина;
		//НовОбъект.ДокументБезНДС = Ложь;
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = НовОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла;
		
		ЗаполнениеДокументов.Заполнить(НовОбъект, ДанныеЗаполнения, Истина);
		
		ЭтотОбъект.Товары.Очистить();
		
		МассивНоменклатуры = Новый Массив;
		
		Для каждого ТекСтрока Из НовОбъект.Товары Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			МассивНоменклатуры.Добавить(НоваяСтрока.Номенклатура);
		КонецЦикла;
		
		//Запрос = Новый Запрос;
		//Запрос.Текст = "ВЫБРАТЬ
		//|	СчетНаОплатуПокупателю.Ссылка КАК Ссылка
		//|ИЗ
		//|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
		//|ГДЕ
		//|	СчетНаОплатуПокупателю.Заказ = &Ссылка
		//|	И СчетНаОплатуПокупателю.ПометкаУдаления = ЛОЖЬ";
		//
		//Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		//
		//Результат = Запрос.Выполнить();
		//Выборка = Результат.Выбрать();
		//
		//Пока Выборка.Следующий() Цикл
		//	ЭтотОбъект.СчетНаОплатуПокупателю = Выборка.Ссылка;		
		//КонецЦикла;
		
		//Запрос = Новый Запрос;
		//Запрос.Текст = "ВЫБРАТЬ
		//| СправочникНомераГТД.Ссылка КАК НомерГТД,
		//| СправочникНомераГТД.Код КАК Код,
		//| СУММА(ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.КоличествоКонечныйОстаток, 0)) КАК КоличествоОстаток,
		//| СУММА(ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.КоличествоОборотДт, 0)) КАК КоличествоПриход,
		//| СУММА(ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.КоличествоОборотКт, 0)) КАК КоличествоРасход,
		//| ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто1, НЕОПРЕДЕЛЕНО) КАК Номенклатура,
		//| ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто3, НЕОПРЕДЕЛЕНО) КАК СтранаПроисхождения
		//| ИЗ
		//| Справочник.НомераГТД КАК СправочникНомераГТД
		//| 	ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
		//| 			,
		//| 			&Период,
		//| 			Период,
		//| 			,
		//| 			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ГТД),
		//| 			,
		//| 			Субконто1 В (&Номенклатура)
		//| 				И Организация = &Организация) КАК ХозрасчетныйОстаткиИОбороты
		//| 	ПО СправочникНомераГТД.Ссылка = ХозрасчетныйОстаткиИОбороты.Субконто2
		//| ГДЕ
		//| НЕ СправочникНомераГТД.СтранаВвозаНеРФ
		//| СГРУППИРОВАТЬ ПО
		//| СправочникНомераГТД.Ссылка,
		//| ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто1, НЕОПРЕДЕЛЕНО),
		//| 	ЕСТЬNULL(ХозрасчетныйОстаткиИОбороты.Субконто3, НЕОПРЕДЕЛЕНО)";
		//
		//Запрос.УстановитьПараметр("Номенклатура", МассивНоменклатуры);
		//Запрос.УстановитьПараметр("Организация", ЭтотОбъект.Организация);
		//Запрос.УстановитьПараметр("Период", ЭтотОбъект.Дата);
		//
		//Результат = Запрос.Выполнить();
		//Выборка = Результат.Выгрузить();
		//
		//Для каждого ТекСтрока Из ЭтотОбъект.Товары Цикл
		//	НуженГТД = ЗначениеЗаполнено(ТекСтрока.Номенклатура.СтранаПроисхождения);
		//	НайденГТД = Ложь;
		//	Если НуженГТД Тогда
		//		НайденныеСтрокиГТД = Выборка.НайтиСтроки(Новый Структура("Номенклатура", ТекСтрока.Номенклатура));
		//		Для каждого ТекНайдСтрока Из НайденныеСтрокиГТД Цикл
		//			Если ТекНайдСтрока.КоличествоОстаток > ТекСтрока.Количество Тогда
		//				ТекСтрока.НомерГТД = ТекНайдСтрока.НомерГТД;
		//				ТекСтрока.СтранаПроисхождения = ТекНайдСтрока.СтранаПроисхождения;
		//				НайденГТД = Истина;
		//				Прервать;
		//			КонецЕсли;
		//		КонецЦикла;
		//	КонецЕсли;
		//	
		//	Если НуженГТД И НЕ НайденГТД Тогда
		//		Сообщить("В реализации по заказу " + Строка(ДанныеЗаполнения.Ссылка) + " в строке " + Строка(ТекСтрока.НомерСтроки) + " не найдена ГТД на остатках. Необходимо подобрать ГТД вручную.");		
		//	КонецЕсли;
		//КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПоступлениеТоваров") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Номер, Проведен");
		ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия;
		
		Если ТипЗнч(ДанныеЗаполнения.ДокОснование) = ТипЗнч(Документы.ЗаказПоставщику.ПустаяСсылка()) Тогда
			ЭтотОбъект.Заказ = ДанныеЗаполнения.ДокОснование;
			ЭтотОбъект.Дата = ДанныеЗаполнения.ДокОснование.ДатаПоступления;
		КонецЕсли;
		
		ДоговорКонтрагентаДЗ = ДанныеЗаполнения.Договор;
		
		Если ТипЗнч(ДанныеЗаполнения.Контрагент) = Тип("СправочникСсылка.Организации") Тогда  
			ИННОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Контрагент, "ИНН");
			ЭтотОбъект.Контрагент = Справочники.Контрагенты.НайтиПоРеквизиту("ИНН", ИННОрганизации);
			
			Если ЗначениеЗаполнено(ДанныеЗаполнения.Договор) Тогда
				ДоговорКонтрагентаДЗ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Договор, "ДоговорКонтрагента");
				
				Если ЗначениеЗаполнено(ДоговорКонтрагентаДЗ) Тогда 
					ЭтотОбъект.Контрагент = ДоговорКонтрагентаДЗ.Владелец;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;

		ЭтотОбъект.СуммаВключаетНДС = Истина;
		ЭтотОбъект.НДСВключенВСтоимость = Ложь;
		ЭтотОбъект.ДоговорКонтрагента = ДоговорКонтрагентаДЗ;
		ЭтотОбъект.ТипЦен = ЭтотОбъект.ДоговорКонтрагента.ТипЦен;
		ЭтотОбъект.ЭтоУниверсальныйДокумент = Истина;
		ЭтотОбъект.ВалютаДокумента = ДанныеЗаполнения.Валюта;
		//Ответственным текущий пользователь
		ЭтотОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		//
		Если Не ЗначениеЗаполнено(ЭтотОбъект.ВалютаДокумента) Тогда
			ЭтотОбъект.ВалютаДокумента = УЧ_Сервер.НациональнаяВалюта();		
		КонецЕсли;
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
			
			Если Не ЗначениеЗаполнено(ЭтотОбъект.Склад) Тогда
				ЭтотОбъект.Склад = ТекСтрока.Склад;	
			КонецЕсли; 
			
		КонецЦикла;  
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.Услуги Цикл
			НоваяСтрока = ЭтотОбъект.Услуги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	сабСоответствиеСчетовИСубконто.СчетБУ КАК СчетБУ,
			|	сабСоответствиеСчетовИСубконто.СчетУУ КАК СчетУУ
			|ИЗ
			|	РегистрСведений.сабСоответствиеСчетовИСубконто КАК сабСоответствиеСчетовИСубконто
			|ГДЕ
			|	сабСоответствиеСчетовИСубконто.СчетУУ = &СчетУУ
			|
			|УПОРЯДОЧИТЬ ПО
			|	сабСоответствиеСчетовИСубконто.СчетБУ.Код ВОЗР";
			
			Запрос.УстановитьПараметр("СчетУУ", ТекСтрока.СчетЗатрат);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				НоваяСтрока.СчетЗатрат = ВыборкаДетальныеЗаписи.СчетБУ;
			КонецЦикла;
			
		КонецЦикла;
				
		НовОбъект = Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовОбъект, ДанныеЗаполнения,,"Дата, Номер");
		НовОбъект.ВидОперации =  Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия;
		
		Если ТипЗнч(ДанныеЗаполнения.ДокОснование) = ТипЗнч(Документы.ЗаказПоставщику.ПустаяСсылка()) Тогда
			НовОбъект.Заказ = ДанныеЗаполнения.ДокОснование;
			НовОбъект.Дата = ДанныеЗаполнения.ДокОснование.ДатаПоступления;
		КонецЕсли;  
		
		НовОбъект.СуммаВключаетНДС = Истина;
		//НовОбъект.ДокументБезНДС = Ложь;
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = НовОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла; 
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.Услуги Цикл
			НоваяСтрока = НовОбъект.Услуги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла;
		
		ЗаполнениеДокументов.Заполнить(НовОбъект, ДанныеЗаполнения, Истина);
		
		ЭтотОбъект.Товары.Очистить();
		ЭтотОбъект.Услуги.Очистить();
		
		МассивНоменклатуры = Новый Массив;
		
		Для каждого ТекСтрока Из НовОбъект.Товары Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			МассивНоменклатуры.Добавить(НоваяСтрока.Номенклатура);
		КонецЦикла;
		
		Для каждого ТекСтрока Из НовОбъект.Услуги Цикл
			НоваяСтрока = ЭтотОбъект.Услуги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		КонецЦикла; 
		
	КонецЕсли;
	
КонецПроцедуры
	
&После("ОбработкаПроведения")
Процедура УУ_ОбработкаПроведения(Отказ, РежимПроведения)
	
	//меняем статус заказа
	Если НЕ ДополнительныеСвойства.Свойство("НеИзменятьСтатусЗаказа") И ЗначениеЗаполнено(Заказ) И ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказПоставщику") И Не Заказ.Статус = Перечисления.СтатусыЗаказовПоставщикам.Закрыт Тогда		
		ЗаказОб = Заказ.ПолучитьОбъект();
		ЗаказОб.Статус = Перечисления.СтатусыЗаказовПоставщикам.Закрыт;
		Если ЗаказОб.Проведен Тогда
			ЗаказОб.Записать(РежимЗаписиДокумента.Проведение);
		Иначе	
			ЗаказОб.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&Перед("ПередЗаписью")
Процедура УУ_ПередЗаписью1(Отказ, РежимЗаписи, РежимПроведения)

	Если Модифицированность() Тогда
		Если ДополнительныеСвойства.Свойство("НеДобавлятьЗаписьВРегистрИзмененных") Тогда
			Если Не ДополнительныеСвойства.НеДобавлятьЗаписьВРегистрИзмененных Тогда
				сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);
			КонецЕсли;
		Иначе
			сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);
		КонецЕсли;
	КонецЕсли;

	Если НЕ ЭтоНовый() Тогда
		Если (ОбменДанными.Загрузка Или ЭтотОбъект.ДополнительныеСвойства.Свойство("ЭтоОбмен")) И АвтообновленияЗаблокированы Тогда
			ИгнорироватьБлокАвтообновления = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("сабИгнорироватьБлокировкуАвтообновленийДокументов");
			Если Не ИгнорироватьБлокАвтообновления Тогда
				ЭтотОбъект.Прочитать();
				ОбменДанными.Загрузка = Не ЭтотОбъект.ДополнительныеСвойства.Свойство("ЭтоОбмен");   
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

