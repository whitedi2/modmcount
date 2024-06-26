﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи)
	
	МассивИсключенийДокументов = Новый Массив;
	МассивИсключенийДокументов.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
	МассивИсключенийДокументов.Добавить(Тип("ДокументСсылка.ЗаказНаВозвратОтКлиента"));
	МассивИсключенийДокументов.Добавить(Тип("ДокументСсылка.ЗаказНаПеремещение"));
	МассивИсключенийДокументов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
	МассивИсключенийДокументов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЧДокумента.Предприятия КАК Предприятие,
	|	ТЧДокумента.СчетДт КАК СчетДт,
	|	ТЧДокумента.СчетКт КАК СчетКт
	|ПОМЕСТИТЬ ВТ_ТЧДокумента
	|ИЗ
	|	&ТЧДокумента КАК ТЧДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТЧДокумента.Предприятие КАК Предприятие,
	|	ВТ_ТЧДокумента.СчетДт КАК СчетДт,
	|	ВТ_ТЧДокумента.СчетКт КАК СчетКт,
	|	ВЫРАЗИТЬ(ВТ_ТЧДокумента.Предприятие КАК Справочник.Предприятия).УчетПоПодразделениям КАК ПредприятиеУчетПоПодразделениям,
	|	ВЫРАЗИТЬ(ВТ_ТЧДокумента.СчетДт КАК ПланСчетов.Учетный).УчетПоПодразделениям КАК СчетДтУчетПоПодразделениям,
	|	ВЫРАЗИТЬ(ВТ_ТЧДокумента.СчетКт КАК ПланСчетов.Учетный).УчетПоПодразделениям КАК СчетКтУчетПоПодразделениям,
	|	ЛОЖЬ КАК СчетКтУчетоПоЦФО,
	|	ЛОЖЬ КАК СчетДтУчетоПоЦФО,
	|	ВЫРАЗИТЬ(ВТ_ТЧДокумента.СчетКт КАК ПланСчетов.Учетный).ЗапретитьИспользоватьВПроводках КАК СчетКтЗапретитьИспользоватьВПроводках,
	|	ВЫРАЗИТЬ(ВТ_ТЧДокумента.СчетДт КАК ПланСчетов.Учетный).ЗапретитьИспользоватьВПроводках КАК СчетДтЗапретитьИспользоватьВПроводках,
	|	ВЫРАЗИТЬ(ВТ_ТЧДокумента.Предприятие КАК Справочник.Предприятия).ВидДеятельности КАК Подразделение
	|ИЗ
	|	ВТ_ТЧДокумента КАК ВТ_ТЧДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ТЧДокумента.СчетДт,
	|	ВТ_ТЧДокумента.Предприятие,
	|	ВТ_ТЧДокумента.СчетКт";
		
	
	Запрос.УстановитьПараметр("ТЧДокумента", ЭтотОбъект.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СоотвПредприятийПодр = Новый Соответствие;
	СоотвПредприятийПодрОсн = Новый Соответствие;
	СоотвСчетДтПодр = Новый Соответствие;
	СоотвСчетКтПодр = Новый Соответствие;
	СоотвСчетДтЦФО = Новый Соответствие;
	СоотвСчетКтЦФО = Новый Соответствие;
	СоотвСчетДтЗапретитьИспользоватьВПроводках = Новый Соответствие;
	СоотвСчетКтЗапретитьИспользоватьВПроводках = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		Если СоотвПредприятийПодр.Получить(Выборка.Предприятие) = Неопределено Тогда
			СоотвПредприятийПодр.Вставить(Выборка.Предприятие, Выборка.ПредприятиеУчетПоПодразделениям);		
		КонецЕсли;
		
		Если СоотвПредприятийПодрОсн.Получить(Выборка.Предприятие) = Неопределено Тогда
			СоотвПредприятийПодрОсн.Вставить(Выборка.Предприятие, Выборка.Подразделение);		
		КонецЕсли;
		
		Если СоотвСчетДтПодр.Получить(Выборка.СчетДт) = Неопределено Тогда
			СоотвСчетДтПодр.Вставить(Выборка.СчетДт, Выборка.СчетДтУчетПоПодразделениям);		
		КонецЕсли;
		
		Если СоотвСчетКтПодр.Получить(Выборка.СчетКт) = Неопределено Тогда
			СоотвСчетКтПодр.Вставить(Выборка.СчетКт, Выборка.СчетКтУчетПоПодразделениям);		
		КонецЕсли;

		Если СоотвСчетДтЦФО.Получить(Выборка.СчетДт) = Неопределено Тогда
			СоотвСчетДтЦФО.Вставить(Выборка.СчетДт, Выборка.СчетДтУчетоПоЦФО);		
		КонецЕсли;
		
		Если СоотвСчетКтЦФО.Получить(Выборка.СчетКт) = Неопределено Тогда
			СоотвСчетКтЦФО.Вставить(Выборка.СчетКт, Выборка.СчетКтУчетоПоЦФО);		
		КонецЕсли;
		
		Если СоотвСчетДтЗапретитьИспользоватьВПроводках.Получить(Выборка.СчетДт) = Неопределено Тогда
			СоотвСчетДтЗапретитьИспользоватьВПроводках.Вставить(Выборка.СчетДт, Выборка.СчетДтЗапретитьИспользоватьВПроводках);		
		КонецЕсли;
		
		Если СоотвСчетКтЗапретитьИспользоватьВПроводках.Получить(Выборка.СчетКт) = Неопределено Тогда
			СоотвСчетКтЗапретитьИспользоватьВПроводках.Вставить(Выборка.СчетКт, Выборка.СчетКтЗапретитьИспользоватьВПроводках);		
		КонецЕсли;

	КонецЦикла;
	
	СЦФакт = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
	
	ЭтоАдминистратор = БюджетныйНаСервере.РольАдминаДоступнаСервер();
	
	//Нельзя удалять записи закрытого периода. Для Контроля 79-го счета  ,узнаем, эт опервое проведение документа , или нет
	РегистраторДвижений = ЭтотОбъект.Отбор.Регистратор.Значение;
	ВыборкаДвижений = РегистрыБухгалтерии.Учетный.ВыбратьПоРегистратору(РегистраторДвижений);		
	ПервоеПроведение = Истина;
	
	ЕстьПредприятие = НЕ РегистраторДвижений.Метаданные().Реквизиты.Найти("Предприятие") = Неопределено;
	//НеПроверятьДатуЗапрета = ЭтотОбъект.ДополнительныеСвойства.Свойство("НеПроверятьДатуЗапрета") И ЭтотОбъект.ДополнительныеСвойства.НеПроверятьДатуЗапрета = Истина;
	
	//НеПроверятьДатуЗапрета = Истина;
	
	
	Пока ВыборкаДвижений.Следующий() Цикл
		
		Если Не МассивИсключенийДокументов.Найти(ТипЗнч(РегистраторДвижений)) = Неопределено Тогда
			Продолжить;		
		КонецЕсли;
		
		//Если НЕ ЭтоАдминистратор Тогда
			
			ГлобальнаяДата = сабОбщегоНазначения.ПолучитьДатуЗапрета(ВыборкаДвижений);    //УЧ_Сервер.ДатаГлобальногоЗапрета();
			ДатаЗакрытияУчетПредприятие = УЧ_Сервер.ДатаБлокировкиИзмененияДокументов(ВыборкаДвижений.Предприятия);
			//ДатаЗакрытияУчет = Макс(ГлобальнаяДата,ДатаЗакрытияУчетПредприятие); 
			ДатаЗакрытияУчет = ГлобальнаяДата; 
			
			Если ВыборкаДвижений.Период <= КонецДня(ДатаЗакрытияУчет) Тогда
				сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
				ВыборкаДвижений,
				"Невозможно удаление записей учетного регистра ранее даты закрытия (" + Формат(ДатаЗакрытияУчет, "ДФ=dd.MM.yy") + ") по предприятию " + Строка(ВыборкаДвижений.Предприятия) + ".",
				,
				,
				"Дата",
				Отказ);
			КонецЕсли;	
			
		//КонецЕсли;
		
		Если ЕстьПредприятие Тогда
			Прервать;			
		КонецЕсли;
		
	КонецЦикла;	
	
	//Обход записей набора записей
	МассивБезСумм = Новый Массив;
	Индекс = 1;
	
	Для каждого Запись Из ЭтотОбъект Цикл
			
		Если Индекс = 1 Тогда //проверяем только первую запись
			
			//Если НЕ ЭтоАдминистратор Тогда
				ГлобальнаяДата = сабОбщегоНазначения.ПолучитьДатуЗапрета(Запись);    //УЧ_Сервер.ДатаГлобальногоЗапрета();
				ДатаЗакрытияУчетПредприятие = УЧ_Сервер.ДатаБлокировкиИзмененияДокументов(Запись.Предприятия);
				//ДатаЗакрытияУчет = Макс(ГлобальнаяДата,ДатаЗакрытияУчетПредприятие);
				ДатаЗакрытияУчет = ГлобальнаяДата; 
				
				Если Запись.Период <= КонецДня(ДатаЗакрытияУчет) И МассивИсключенийДокументов.Найти(ТипЗнч(РегистраторДвижений)) = Неопределено Тогда
					сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
					Запись,
					"Невозможно формирование записей учетного регистра ранее даты закрытия (" + Формат(ДатаЗакрытияУчет, "ДФ=dd.MM.yy") + ") по предприятию " + Строка(Запись.Предприятия) + ".",
					,
					,
					"Дата",
					Отказ);
				КонецЕсли;
				
				Если ЕстьПредприятие Тогда
					Прервать;			
				КонецЕсли;
				
			//КонецЕсли; 
			
		КонецЕсли;
		
		//подразделение основное заполняем
		Если Не СоотвПредприятийПодр.Получить(Запись.Предприятия) Тогда
			
			Если ЗначениеЗаполнено(Запись.СчетДт) И СоотвСчетДтПодр.Получить(Запись.СчетДт) Тогда
				Запись.ПодразделениеДт = СоотвПредприятийПодрОсн.Получить(Запись.Предприятия);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Запись.СчетКт) И СоотвСчетКтПодр.Получить(Запись.СчетКт) Тогда
				Запись.ПодразделениеКт = СоотвПредприятийПодрОсн.Получить(Запись.Предприятия);
			КонецЕсли;
			
		КонецЕсли;
		
		//Проверяем сценарий плана
		Если Не ЗначениеЗаполнено(Запись.СценарийПлана) Тогда 
			Запись.СценарийПлана = СЦФакт;
		КонецЕсли;
		
		//проверяем дальше		
		Если ЗначениеЗаполнено(Запись.СчетДт) И СоотвСчетДтЗапретитьИспользоватьВПроводках.Получить(Запись.СчетДт) Тогда
			Сообщить("Счет "+ Запись.СчетДт + " запрещено использовать в проводках. Для правильного формирования проводки попробуйте использовать субсчет. ");
			Отказ = Истина;
			Возврат		
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.СчетКт) И СоотвСчетКтЗапретитьИспользоватьВПроводках.Получить(Запись.СчетКт) Тогда
			Сообщить("Счет "+ Запись.СчетКт + " запрещено использовать в проводках. Для правильного формирования проводки попробуйте использовать субсчет. ");
			Отказ = Истина;
			Возврат		
		КонецЕсли;
		
		//Проверка на доступность предприятия пользователю
		Если (ПараметрыСеанса.ДоступныеПредприятия.Найти(Запись.Предприятия) = Неопределено) ИЛИ НЕ ПараметрыСеанса.ДоступныеПредприятияПросмотр.Найти(Запись.Предприятия) = Неопределено Тогда
			
			Если НЕ БюджетныйНаСервере.РольФинансистаДоступна() И НЕ РольДоступна("ОФК") Тогда  //исключение для тех, кто классифицирует Движения
				Сообщить("При проведении документа обнаружено недоступное для данного пользователя предприятие " + Запись.Предприятия + ". Проведение по регистру ""Учетный"" отменено");
				Отказ = истина;			
			КонецЕсли;
			
		КонецЕсли;
		
		//Незаполненные значение произвольного субконто принудительно обращаем в Неопределено
		//Если Запись.СубконтоДт.Произвольное <> Неопределено И Не ЗначениеЗаполнено(Запись.СубконтоДт.Произвольное) Тогда
		//	Запись.СубконтоДт.Произвольное = Неопределено;
		//КонецЕсли;
		
		//Если Запись.СубконтоКт.Произвольное <> Неопределено И Не ЗначениеЗаполнено(Запись.СубконтоКт.Произвольное) Тогда
		//	Запись.СубконтоКт.Произвольное = Неопределено;
		//КонецЕсли;
		
		Для Каждого ТекСубконтоДт Из Запись.СубконтоДт Цикл
			
			Если ЗначениеЗаполнено(ТекСубконтоДт.Значение) Или ТипЗнч(ТекСубконтоДт.Значение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТекСубконтоДт.Ключ.ТипЗначения.Типы().Количество() > 1 Тогда
				Запись.СубконтоДт[ТекСубконтоДт.Ключ] = Неопределено;
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого ТекСубконтоКт Из Запись.СубконтоКт Цикл
			
			Если ЗначениеЗаполнено(ТекСубконтоКт.Значение) Или ТипЗнч(ТекСубконтоКт.Значение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТекСубконтоКт.Ключ.ТипЗначения.Типы().Количество() > 1 Тогда
				Запись.СубконтоКт[ТекСубконтоКт.Ключ] = Неопределено;
			КонецЕсли;
			
		КонецЦикла; 	
				
		//пустые движения
		КоличествоДт = ?(Запись.КоличествоДт = Null, 0, Запись.КоличествоДт);
		КоличествоКт = ?(Запись.КоличествоКт = Null, 0, Запись.КоличествоКт);
		
		Если НЕ Запись.Сумма И НЕ КоличествоДт И НЕ КоличествоКт Тогда
			МассивБезСумм.Добавить(Запись);
		КонецЕсли;
		
		Индекс = Индекс + 1;	
	КонецЦикла;
	
	Для каждого ТекЗапись Из МассивБезСумм Цикл
		ЭтотОбъект.Удалить(ТекЗапись);		
	КонецЦикла; 
	
КонецПроцедуры 
